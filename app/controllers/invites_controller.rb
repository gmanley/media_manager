class InvitesController < ApplicationController
  responders :flash, :http_cache, :collection

  respond_to :html

  before_action :require_login
  before_action :set_invite, only: [:edit, :update, :destroy]

  def index
    authorize(Invite)
    @invites = InviteDecorator.decorate_collection(policy_scope(Invite))
    respond_with(@invites)
  end

  def new
    @invite = Invite.new
    authorize(@invite)
    respond_with(@invite)
  end

  def create
    authorize(Invite)

    attributes = permitted_attributes(Invite)
    attributes.merge!(sender_id: current_user.id) unless attributes[:sender_id]

    @invite = CreateInvite.new(attributes).perform
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
end
