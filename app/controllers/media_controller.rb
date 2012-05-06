class MediaController < ApplicationController
  respond_to :html, :json, :js

  def index
    @media = Media.all.page(params[:page]).per(100)
    respond_with(@media)
  end

  def show
    @media = Media.find(params[:id])
    respond_with(@media)
  end
end