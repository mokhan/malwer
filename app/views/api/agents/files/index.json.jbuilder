json.array!(@files) do |file|
  json.extract! agent, :fingerprint, :state
  json.url agent_file_url([agent, file], format: :json)
end
