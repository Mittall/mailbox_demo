class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_messageable

  validates :email, :presence => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates_uniqueness_of :email
  
  # You'd, probably, want to have a separate name column instead
  def name
    self.email
  end

  def mailboxer_email(object)
    self.email
  end
end
