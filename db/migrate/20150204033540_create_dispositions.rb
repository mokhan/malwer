class CreateDispositions < ActiveRecord::Migration
  def change
    create_table :dispositions, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :fingerprint
      t.integer :state

      t.timestamps null: false
    end
    add_index :dispositions, :fingerprint, unique: true
  end
end
