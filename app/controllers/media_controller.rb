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

  def edit
    @media = Media.find(params[:id])
    respond_with(@media)
  end

  def update
    @media = Media.find(params[:id])
    @media.update_attributes(params[:media])
    respond_with(@media)
  end

  def destroy
    @media = Media.find(params[:id])
    @media.destroy
    respond_with(@media, location: root_path)
  end
end