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
    disposition = Disposition.find_by(fingerprint: fingerprint)
    disposition.file_reports.create!(data: report)
  end
end
