module ClientMethods
  extend ActiveSupport::Concern

  included do
    has_many :logs, as: :client
    has_many :accesses, as: :client
    has_many :services, through: :accesses
    before_create :generate_api_key
  end



  ### API Key related...
  #
  def is_authorized? token
    self.api_key == token
  end

  def regenerate_api_key
    generate_api_key
    save!
  end

  private
  def generate_api_key
    begin
      self.api_key = self.class.name[0].downcase
      self.api_key += Digest::SHA256.new.update(SecureRandom.base64).to_s
    end while self.class.exists?(api_key: api_key)
  end
end
# vim: set ts=2 sw=2 expandtab:
