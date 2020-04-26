class MembersController < ApplicationController
  def index
    @dataset = Dataset.find(params["dataset_id"])
    @members = User.users_of_dataset(params["dataset_id"])
    render layout: "dataset"
  end
end
