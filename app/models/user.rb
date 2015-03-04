class User < ActiveRecord::Base
  has_many :logs, as: :client
  before_create :generate_api_key

  private
  def generate_api_key
    begin
      self.api_key = Digest::SHA256.new.to_s
    end while self.class.exists?(api_key: api_key)
  end
end
# vim: set ts=2 sw=2 expandtab:
