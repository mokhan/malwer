json.array!(@dispositions) do |disposition|
  json.extract! disposition, :id, :fingerprint, :state
  json.url disposition_url(disposition, format: :json)
end
