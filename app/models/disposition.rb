class Disposition < ActiveRecord::Base
  enum state: [ :clean, :malicious, :unknown ]
  attr_readonly :fingerprint
  has_many :file_reports

  validates_uniqueness_of :fingerprint
  validates_presence_of :fingerprint, :state

  def to_param
    fingerprint
  end

  def self.create_for(fingerprint, report)
    disposition = Disposition.find_by(fingerprint: fingerprint)
    disposition = Disposition.new(fingerprint: fingerprint) if disposition.nil?
    disposition.state = :unknown
    disposition.file_reports.create!(data: report)
  end
end
