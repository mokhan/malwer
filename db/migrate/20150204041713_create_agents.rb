class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :hostname

      t.timestamps null: false
    end
  end
end
