json.array!(@dispositions) do |disposition|
  json.extract! disposition, :fingerprint, :state
  json.url disposition_url(disposition, format: :json)
end
