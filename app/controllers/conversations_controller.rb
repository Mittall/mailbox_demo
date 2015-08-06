class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :mailbox
  before_action :get_conversation, :only => [:show, :update, :destroy]

  def create

    recipient_emails = conversation_params(:recipients).split(',')
    #return render :text => recipient_emails.length
    #return render :text => email
    for i in 0..recipient_emails.length
      recipients = User.where(email: recipient_emails).all
    end
      conversation = current_user.send_message(recipients, *conversation_params(:body, :subject)).conversation
      redirect_to conversation_path(conversation)
  end
  
  def index
    if params[:name] == "inbox"
      @conversations = @mailbox.inbox.paginate(:page => params[:page], :per_page => 10)
    elsif params[:name] == "sentbox"
      @conversations = @mailbox.sentbox.paginate(:page => params[:page], :per_page => 10) 
    elsif params[:name] == "trash"
      @conversations = @mailbox.trash.paginate(:page => params[:page], :per_page => 10)
    else
      @conversations = @mailbox.inbox.paginate(:page => params[:page], :per_page => 10)
    end    
  end  

  def new 
    #@conversation = conversation.new
    #render :text => get_email
  end

  def show
  end

  def reply
    current_user.reply_to_conversation(get_conversation, *message_params(:body, :subject))
    redirect_to conversation_path(get_conversation)
  end

  def trash
    get_conversation.move_to_trash(current_user)
    redirect_to :conversations
  end

  def untrash
    get_conversation.untrash(current_user)
    redirect_to :conversations
  end

  private

  def mailbox
    @mailbox = current_user.mailbox
  end

  def get_conversation
    @conversation = @mailbox.conversations.find(params[:id])
  end

  def conversation_params(*keys)
    fetch_params(:conversation, *keys)
  end

  def message_params(*keys)
    fetch_params(:message, *keys)
  end

  def fetch_params(key, *subkeys)
    params[key].instance_eval do
      case subkeys.size
      when 0 then self
      when 1 then self[subkeys.first]
      else subkeys.map{|k| self[k] }
      end
    end
  end


end
