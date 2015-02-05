if @file
  json.extract! @file, :fingerprint, :state
else
  json.fingerprint @fingerprint
  json.state "unknown"
end
