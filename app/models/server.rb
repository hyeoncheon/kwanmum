class Server < ActiveRecord::Base
  include ClientMethods

  def name  # normalize for polymorphic 'client'
    if not self.hostname.blank?
      self.hostname
    elsif not self.address.blank?
      self.address
    else
      'unknown'
    end
  end
end
# vim: set ts=2 sw=2 expandtab:
