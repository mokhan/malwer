class Event < ActiveRecord::Base
  belongs_to :agent
  has_secure_password
end
