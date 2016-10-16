json.extract! user, :id, :name, :username, :api_key, :password, :created_at, :updated_at
json.url user_url(user, format: :json)