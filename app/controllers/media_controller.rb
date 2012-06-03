class MediaController < ApplicationController
  respond_to :html, :json

  def index
    if query.present?
      @media = Media.tire.search(query,
                 page: page, per_page: per_page,
                 sort: "#{sort_column} #{sort_direction}")
    else
      @media = Media.order_by([[sort_column, sort_direction]])
                    .page(page).per(per_page)
    end

    respond_with(@media)
  end

  def show
    @media = Media.find(params[:id])
    respond_with(@media)
  end

  def download
    @media = Media.find(params[:id])
    if download_url = @media.download_url
      redirect_to(download_url)
    else
      send_file(@media.file_path, filename: @media.filename)
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