json.array!(@agents) do |agent|
  json.extract! agent, :id, :hostname
  json.url agent_url(agent, format: :json)
end
