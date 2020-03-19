# frozen_string_literal: true

module ApplicationHelper
   # current_user methods
  def super_admin?
    current_user.has_role? :super_admin
  end

  def election_admin?(election)
    current_user == election.admin
  end
end
