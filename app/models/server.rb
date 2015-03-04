class Server < ActiveRecord::Base
  has_many :logs, as: :client
  before_create :generate_api_key

  def is_authorized? token
    self.api_key == token
  end

  def name  # normalize for polymorphic 'client'
    if not self.hostname.blank?
      self.hostname
    elsif not self.address.blank?
      self.address
    else
      'unknown'
    end
  end

  private
  def generate_api_key
    begin
      self.api_key = Digest::SHA256.new.to_s
    end while self.class.exists?(api_key: api_key)
  end
end
# vim: set ts=2 sw=2 expandtab:
