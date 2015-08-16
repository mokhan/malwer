class Document
  include Cequel::Record

  key :id, :timeuuid, auto: true
  column :fingerprint, :text
  column :path, :text
  column :filename, :text
  column :agent_id, :uuid, index: true
  timestamps
end
