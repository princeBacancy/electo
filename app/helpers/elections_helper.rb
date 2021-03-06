# frozen_string_literal: true

# election view helper
module ElectionsHelper
  def voting_page_content(election)
    if election.approval_status != 'approved'
      'Caution!!! =>   election is not permitted to be live'

    elsif election.status != 'live'
      'Caution!!! => election is not live'

    elsif election.voters.exists?(voter_id: current_user.id)
      'Caution!!! => you had already vote for this election'

    elsif !election.requests.exists?(request_sender_id: current_user.id,
                                     purpose: 'voter', status: :approved) &&
          (current_user.id != election.admin_id)
      'Caution!!! => you are not authorized to vote'
    end
  end

  def deadline?(election)
    election.deadline_for_registration.strftime('%d %b %Y %H:%M') <= DateTime.now.strftime('%d %b %Y %H:%M')
  end

  def request_exist?(election)
    election.requests.exists?(request_sender_id: current_user.id, purpose: :voter, status: :approved)
  end
end
