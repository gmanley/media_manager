class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user || User.new(role: 'guest')
    minimum_role = Roles[Rails.application.config.settings.minimum_role]
    if @user.role_class < minimum_role
      raise Pundit::NotAuthorizedError, "You don't mean the minium user role of #{minimum_role}"
    end
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(user, scope)
      @user = user || User.new(role: 'guest')
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope
  end
end
