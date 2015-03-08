json.array!(@accesses) do |access|
  json.extract! access, :id, :description, :client_id, :client_type, :service_id, :permissions
  json.url access_url(access, format: :json)
end
