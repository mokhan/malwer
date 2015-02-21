class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :username, null: false
      t.string :password_digest, null: false

      t.timestamps null: false
    end

    add_index :users, :username, unique: true
  end
end
