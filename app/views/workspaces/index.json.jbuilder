json.array!(@workspaces) do |workspace|
  json.extract! workspace, :id, :name, :group_id, :user_id
  json.url workspace_url(workspace, format: :json)
end
