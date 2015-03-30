json.array!(@groups) do |group|
  json.extract! group, :id, :name, :account_id, :root_group_id, :parent_group_id, :account_state
  json.url group_url(group, format: :json)
end
