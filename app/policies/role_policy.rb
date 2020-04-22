class RolePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?; false; end

  def update?; false; end

  def destroy; false; end

end
