class VideosController < ApplicationController
  respond_to :html, :json

  def index
    if query.present?
      @videos = Video.search(query).per(per_page).page(page).records.order(sort_column => sort_direction)
    else
      @videos = Video.order(sort_column => sort_direction)
                     .page(page).per(per_page)
    end

    respond_with(@videos)
  end

  def show
    @video = Video.find(params[:id])
    respond_with(@video)
  end

  def download
    video = Video.find(params[:id])
    if download_url = video.download_url
      redirect_to(download_url)
    else
      send_file(video.file_path, filename: video.name)
    end
  end

  private
  def query
    params[:sSearch]
  end

  def sort_direction
    params[:sSortDir_0] || :asc
  end

  def sort_column
    columns = %w[name air_date duration]
    columns[params[:iSortCol_0].to_i]
  end

  def page
    if params[:page]
      params[:page]
    else
      params[:iDisplayStart].to_i / per_page + 1
    end
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end
end
