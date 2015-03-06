class Log < ActiveRecord::Base
  belongs_to :client, polymorphic: true
  default_scope { where(dismissed: false).order('created_at DESC') }
end
