module ProposalsHelper
  def inbox_proposals_count
    Proposal.where(:receiver_id => current_user.employee_ids).count
  end

  def outbox_proposals_count
    Proposal.where(:supplier_id => current_user.employee_ids).count
  end
end
