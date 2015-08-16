class Agent < ActiveRecord::Base
  has_many :events, dependent: :destroy

  def files
    Document.where(agent_id: id)
  end
end
