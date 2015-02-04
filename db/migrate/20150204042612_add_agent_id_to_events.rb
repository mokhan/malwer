class AddAgentIdToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :agent, index: true
  end
end
