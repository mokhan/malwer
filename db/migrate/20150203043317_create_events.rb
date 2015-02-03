class CreateEvents < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')
    create_table :events, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :name
      t.json :data

      t.timestamps null: false
    end
  end
end
