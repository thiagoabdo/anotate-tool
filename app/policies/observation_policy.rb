class ObservationPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end


  def create? ; user_is_owner_of_dataset? ; end
  def update? ; user_is_owner_of_dataset? ; end
  def destroy? ; user_is_owner_of_dataset? ; end
  def put_active_learn? ; user_is_owner_of_dataset? ; end
  def put_interactive_learn? ; user_is_owner_of_dataset? ; end
  def put_kfold? ; user_is_owner_of_dataset? ; end
  def delete_active_learn? ; user_is_owner_of_dataset? ; end
  def delete_interactive_learn? ; user_is_owner_of_dataset? ; end
  def delete_kfold? ; user_is_owner_of_dataset? ; end


  private
  def user_is_owner_of_dataset?
    Role.owners_of(@record.dataset.id).pluck(:user_id).include?(@user.id)
  end

end
