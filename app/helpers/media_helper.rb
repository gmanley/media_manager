module MediaHelper

  def escape_snapshot_url(url)
    url_array = File.split(url)
    url_array << CGI.escape(url_array.pop)
    File.join(url_array)
  end

  def view_type
    params[:view_type] || 'thumbnails'
  end
end
