module Admin
  class HostProviderAccountsController < ApplicationController
    respond_to :html

    before_action :require_login
    before_action :set_host_provider_account, only: [:show, :edit, :update, :destroy]

    def index
      authorize(HostProviderAccount)
      @host_provider_accounts = policy_scope(HostProviderAccount)
      respond_with(@host_provider_accounts)
    end

    def show
      authorize(@host_provider_account)
      respond_with(@host_provider_account)
    end

    def new
      @host_provider_account = HostProviderAccount.new
      authorize(@host_provider_account)
      respond_with(@host_provider_account)
    end

    def edit
      authorize(@host_provider_account)
      respond_with(@host_provider_account)
    end

    def create
      authorize(HostProviderAccount)
      @host_provider_account = HostProviderAccount.create(host_provider_account_params)
      respond_with(@host_provider_account)
    end

    def update
      authorize(@host_provider_account)
      @host_provider_account.update(host_provider_account_params)
      respond_with(@host_provider_account)
    end

    def destroy
      authorize(@host_provider_account)
      @host_provider_account.destroy
      respond_with(@host_provider_account)
    end

    private

    def set_host_provider_account
      @host_provider_account = HostProviderAccount.find(params[:id])
    end

    def host_provider_account_params
      params.require(:host_provider_account).permit(
        :host_provider_id, :name, :username, :password, :online, :total_storage
      )
    end
  end
end
