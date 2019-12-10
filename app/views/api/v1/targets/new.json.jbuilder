json.topics(@topics) do |topic|
  json.extract! topic, :id, :name
end
