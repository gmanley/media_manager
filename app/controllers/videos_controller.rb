class VideosController < ApplicationController
  respond_to :html, :json

  def index
    if query.present?
      filtered_videos = Video.search(query)
      @video_count = filtered_videos.count
      @videos = filtered_videos.per(per_page).page(page).records.order(sort_column => sort_direction)
    else
      @videos = Video.order(sort_column => sort_direction)
                     .page(page).per(per_page)
      @video_count = @videos.count
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
    params.dig(:search, :value)
  end

  def sort_direction
    sort_options&.fetch(:dir) || :asc
  end

  def sort_column
    columns = %w[name air_date file_hash]
    return columns.first unless sort_options
    columns[sort_options[:column].to_i]
  end

  def sort_options
    params.dig(:order, '0')
  end

  def page
    if params[:page]
      params[:page]
    else
      params[:start].to_i / per_page + 1
    end
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end
end
