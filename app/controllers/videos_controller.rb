class VideosController < ApplicationController
  respond_to :html, :json

  before_action :set_video, only: [:show, :edit, :update, :download]

  def index
    authorize(Video)
    if query.present?
      @videos = VideosIndex::Video.query(match: { name: query })
        .order(sort_column(search_sort_columns) => sort_direction)
        .page(page).per(per_page)
    else
      @videos = Video.order(sort_column => sort_direction)
        .page(page).per(per_page)
    end

    respond_with(@videos)
  end

  def show
    authorize(@video)
    @uploads = policy_scope(@video.uploads)
    @snapshots = @video.snapshots.processed.order(video_time: :asc)
    respond_with(@video)
  end

  def edit
    authorize(@video)
    respond_with(@video)
  end

  def update
    authorize(@video)
    @video.update(video_params)
    respond_with(@video)
  end

  def download
    authorize(@video)
    if download_url = video.download_url
      redirect_to(download_url)
    else
      send_file(video.file_path, filename: video.name)
    end
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end

  def video_params
    params.require(:video).permit(:name, :external_id, :air_date)
  end

  def query
    params.dig(:search, :value)
  end

  def sort_direction
    sort_options&.fetch(:dir) || :desc
  end

  # Elasticsearch columns that are indexed for advanced search can't be sorted.
  # To get around this you can create sortable duplicates of the columns
  # that have a keyword type which can be sorted.
  def search_sort_columns
    %w[name_sortable air_date file_hash external_id]
  end

  def index_sort_columns
    %w[name air_date file_hash external_id]
  end

  def sort_column(column_list = index_sort_columns)
    return column_list.first unless sort_options
    column_list[sort_options[:column].to_i]
  end

  def sort_options
    params.dig(:order, '0')
  end

  def page
    params[:page] || params[:start].to_i / per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end
end
