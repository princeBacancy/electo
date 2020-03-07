module ElectionsHelper
  def voting_page_content(election)
    if election.approval_status != "approved"
      "Caution!!! =>   election is not permitted to be live"  

    elsif election.status != "live"
      "Caution!!! => election is not live"

    elsif election.voters.exists?(voter_id: current_user.id)
      "Caution!!! => you had already vote for this election"

    elsif !election.requests.exists?(request_sender_id:current_user.id, purpose: "voter",
          status: :approved) and current_user.id != election.admin_id
      "Caution!!! => you are not authorized to vote"
    end
  end
end
