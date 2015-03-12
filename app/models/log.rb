class Log < ActiveRecord::Base
  belongs_to :client, polymorphic: true
  default_scope { where(dismissed: false).order('created_at DESC') }

  def mesg
    if self.message
      self.message
    else
      self.mesg_generated
    end
  end

  def mesg_generated
    gmesg = ''
    gmesg += self.actor if self.actor
    gmesg += '> ' + self.action if self.action
    gmesg += ' (' + self.reason + ')' if self.reason
    gmesg
  end
end
# vim: set ts=2 sw=2 expandtab:
