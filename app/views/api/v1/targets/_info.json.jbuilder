json.target do
  json.extract! @target, :id, :topic_id, :user_id, :title, :radius, :latitude, :longitude
end
