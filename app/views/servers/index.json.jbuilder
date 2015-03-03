json.array!(@servers) do |server|
  json.extract! server, :id, :uuid, :hostname, :address, :description, :api_key
  json.url server_url(server, format: :json)
end
