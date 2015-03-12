class Service < ActiveRecord::Base
  has_many :accesses
  has_many :servers, through: :accesses, source_type: "Server", source: "client"
  has_many :users, through: :accesses, source_type: "User", source: "client"
end
