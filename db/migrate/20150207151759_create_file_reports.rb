class CreateFileReports < ActiveRecord::Migration
  def change
    create_table :file_reports, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.uuid :disposition_id
      t.json :data

      t.timestamps null: false
    end
  end
end
