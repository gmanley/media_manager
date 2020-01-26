class VideosController < ApplicationController
  respond_to :html, :json

  def index
    if query.present?
      # binding.pry
      filtered_videos = Video.search do
        fulltext(query)
        order_by(sort_column.to_sym, :sort_direction)
        paginate(page: page, per_page: per_page)
      end
      @video_count = filtered_videos.total_count
      @videos = filtered_videos.results
    else
      @video_count = Video.count
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
    params.dig(:search, :value)
  end

  def sort_direction
    sort_options&.fetch(:dir) || :desc
  end

  def sort_column
    columns = %w[name air_date file_hash csv_number]
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
