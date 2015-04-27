json.array!(@proposals) do |proposal|
  json.extract! proposal, :id, :task_id, :supplier_id, :receiver_id
  json.url proposal_url(proposal, format: :json)
end
