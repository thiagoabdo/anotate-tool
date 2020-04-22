class DatasetPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?; user_is_owner_of_record?; end

  def destroy?; user_is_owner_of_record?; end

  def create?; true; end


  private
  def user_is_owner_of_record?
    Role.owners_of(@record.id).pluck(:user_id).include?(@user.id)
  end
end
