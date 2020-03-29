class InvitesController < ApplicationController
  respond_to :html

  before_action :require_login
  before_action :set_invite, only: [:edit, :update, :destroy]

  def index
    authorize(Invite)
    @invites = policy_scope(Invite)
    respond_with(@invites)
  end

  def new
    @invite = Invite.new
    authorize(@invite)
    respond_with(@invite)
  end

  def create
    authorize(Invite)
    @invite = Invite.create(invite_params)
    respond_with(@invite)
  end

  def edit
    authorize(@invite)
    respond_with(@invite)
  end

  def update
    authorize(@invite)
    @invite.update(invite_params)
    respond_with(@invite)
  end

  def destroy
    authorize(@invite)
    @invite.destroy
    respond_with(@invite)
  end

  private

  def set_invite
    @invite = Invite.find(params[:id])
  end

  def invite_params
    params.require(:invite).permit(:email, :role, :created_by_user_id)
  end
end
