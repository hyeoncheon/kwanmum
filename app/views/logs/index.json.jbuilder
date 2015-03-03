json.array!(@logs) do |log|
  json.extract! log, :id, :category, :level, :time, :service, :hostname, :process, :message, :actor, :action, :target, :reason, :tag, :client_id, :client_type
  json.url log_url(log, format: :json)
end
