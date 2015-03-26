json.array!(@conversations) do |conversation|
  json.extract! conversation, :id, :subject
  json.url conversation_url(conversation, format: :json)
end
