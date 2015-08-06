class Conversation < ActiveRecord::Base

  re = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/u
  validate :recipients_format
  def recipients_format
    unless recipients.all? { |r| r =~ re }
      errors[:recipients] = "are not all valid email addresses"
    end
  end

end
