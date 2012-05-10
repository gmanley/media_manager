class MediaController < ApplicationController
  respond_to :html

  def index
    @media = Media.page(params[:page]).per(50).asc(:name)
    respond_with(@media)
  end

  def show
    @media = Media.find(params[:id])
    respond_with(@media)
  end

  def download
    @media = Media.find(params[:id])
    send_file(@media.file_path, filename: @media.filename)
  end
end