class Query
  include Cequel::Record

  key :agent_id, :uuid
  column :path, :text
  column :fingerprint, :text
end
