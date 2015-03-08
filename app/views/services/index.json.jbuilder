json.array!(@services) do |service|
  json.extract! service, :id, :name, :description, :base_url, :is_public
  json.url service_url(service, format: :json)
end
