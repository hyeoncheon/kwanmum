json.array!(@users) do |user|
  json.extract! user, :id, :name, :mail, :roles, :image, :siso_uid, :siso_gid, :siso_active, :last_seen
  json.url user_url(user, format: :json)
end
