class FingerprintLookupJob < ActiveJob::Base
  #ENDPOINT = "https://www.virustotal.com/vtapi/v2/file/report"
  ENDPOINT = "https://www.virustotal.com/api/get_file_report.json"
  queue_as :default

  def perform(fingerprint)
    response = Typhoeus.post(ENDPOINT, params: {
      resource: fingerprint,
      apiKey: ENV.fetch("VIRUS_TOTAL_API_KEY"),
    })
    report = JSON.parse(response.response_body)
    puts "+++"
    puts response.response_body.inspect
    puts "---"
    puts report.inspect
    puts "+++"
    Disposition.create_for(fingerprint, report)
  end
end
