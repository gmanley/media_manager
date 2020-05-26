class UsersController < Clearance::BaseController
  before_action :redirect_signed_in_users, only: [:create, :new]
  skip_before_action :require_login, only: [:create, :new], raise: false

  def new
    attributes = {}

    if params[:invite_id]
      @invite = Invite.find_by(id: params[:invite_id])
      attributes.merge!(email: @invite.email, invite_id: params[:invite_id]) if @invite
    end

    @user = User.new(attributes)
    authorize(@user)
    render template: "users/new"
  end


  def create
    @invite = Invite.find_by(id: params[:invite_id])
    @user = User.new(permitted_attributes(User))
    @user.role = @invite.role if @invite

    authorize(@user)

    if @user.save
      @invite&.update(recipient_id: @user.id, redeemed_at: DateTime.now)

      sign_in @user
      redirect_back_or url_after_create
    else
      render template: 'users/new'
    end
  end

  def show
    @user = User.find(params[:id])
    authorize(@user)
  end

  private

  def redirect_signed_in_users
    if signed_in?
      redirect_to Clearance.configuration.redirect_url
    end
  end

  def url_after_create
    Clearance.configuration.redirect_url
  end

  def user_params
    params.require(:user).permit(:email, :password, :invite_id)
  end
end
