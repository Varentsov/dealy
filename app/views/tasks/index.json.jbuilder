json.array!(@tasks) do |task|
  json.extract! task, :id, :title, :description, :deadline, :fire
  json.url task_url(task, format: :json)
end
