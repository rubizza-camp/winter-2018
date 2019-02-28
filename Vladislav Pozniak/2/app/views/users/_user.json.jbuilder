json.extract! user, :id, :email, :first_name, :last_name, :age, :weight, :height, :created_at, :updated_at
json.url user_url(user, format: :json)
