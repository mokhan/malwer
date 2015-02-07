class FileReport < ActiveRecord::Base
  belongs_to :disposition
  validates_presence_of :disposition, :data
end
