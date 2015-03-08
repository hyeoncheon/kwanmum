class Access < ActiveRecord::Base
  belongs_to :client, polymorphic: true
  belongs_to :service
end
