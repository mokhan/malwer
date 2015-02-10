class AddAgentIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :agent_id, :uuid, null: false
    add_index :events, :agent_id
  end
end
