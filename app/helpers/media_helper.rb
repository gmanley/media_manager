module MediaHelper

  def view_type
    params[:view_type] || 'thumbnails'
  end
end
