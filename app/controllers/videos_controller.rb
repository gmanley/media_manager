class VideosController < ApplicationController
  respond_to :html, :json

  def index
    if query.present?
      @videos = Video.tire.search(query,
                 page: page, per_page: per_page,
                 sort: "#{sort_column} #{sort_direction}")
    else
      @videos = Video.order_by([[sort_column, sort_direction]])
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
      send_file(video.file_path, filename: video.filename)
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
    column = columns[params[:iSortCol_0].to_i]
    if column == 'name' && query.present?
      column << '_sortable'
    else
      column
    end
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