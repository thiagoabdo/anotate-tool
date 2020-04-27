class MembersController < ApplicationController
  def index
    @dataset = Dataset.find(params["dataset_id"])
    roles = Role.where(:dataset_id => params["dataset_id"]).includes(:user)
    @members = []
    roles.each do |role|
      user = role.user
      @members.push(user)
    end
    
    render layout: "dataset"
  end
end
