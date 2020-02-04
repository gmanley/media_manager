class UploadPolicy < ApplicationPolicy
  def show?
    user.role_class >= Roles[:consumer]
  end

  class Scope
    def resolve
      if user.role_class >= Roles[:contributor]
        scope.all
      else
        scope.where(public: true)
      end
    end
  end
end
