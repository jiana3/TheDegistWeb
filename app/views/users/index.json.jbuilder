json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :bio, :email, :username, :password_digest, :interests
  json.url user_url(user, format: :json)
end
