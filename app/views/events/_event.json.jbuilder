json.extract! event, :id, :name, :date, :location, :description, :host_id, :created_at, :updated_at
json.url event_url(event, format: :json)
