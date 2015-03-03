class User < ActiveRecord::Base
  has_many :logs, as: :client
end
# vim: set ts=2 sw=2 expandtab:
