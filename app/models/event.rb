class Event < ActiveRecord::Base
  belongs_to :agent
  validates_presence_of :agent
end
