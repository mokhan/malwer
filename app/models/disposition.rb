class Disposition < ActiveRecord::Base
  enum state: [ :clean, :malicious, :unknown ]
  attr_readonly :fingerprint

  validates_uniqueness_of :fingerprint
  validates_presence_of :fingerprint, :state

  def to_param
    fingerprint
  end
end
