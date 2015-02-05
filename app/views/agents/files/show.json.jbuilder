if @file
  json.extract! @file, :fingerprint, :state
else
  json.fingerprint params[:fingerprint]
  json.state "unknown"
end
