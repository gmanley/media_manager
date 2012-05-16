class MediaController < ApplicationController
  respond_to :html, :json

  def index
    @media = Media.order_by([[sort_column, sort_direction]])
                  .page(params[:page]).per(25)

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

  private
  def sort_direction
    params[:sSortDir_0] || :asc
  end

  def sort_column
    columns = %w[name air_date duration]
    columns[params[:iSortCol_0].to_i]
  end

  def page
    params[:iDisplayStart].to_i / per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end
end