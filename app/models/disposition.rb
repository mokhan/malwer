class Disposition < ActiveRecord::Base
  enum state: [ :clean, :malicious, :unknown ]
  attr_readonly :fingerprint

  validates_uniqueness_of :fingerprint

  def to_param
    fingerprint
  end
end
