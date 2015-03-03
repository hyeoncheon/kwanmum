class Log < ActiveRecord::Base
  belongs_to :client, polymorphic: true
end
