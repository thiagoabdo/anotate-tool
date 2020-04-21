json.extract! observation, :id, :name, :dataset_id, :created_at, :updated_at
json.url observation_url(observation, format: :json)
