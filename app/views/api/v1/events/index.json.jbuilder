json.array! @events do |event|
  json.extract! event, :id, :name, :location, :date, :event_url
end
