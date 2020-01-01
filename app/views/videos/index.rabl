object false
node(:sEcho) { params[:sEcho].to_i }
node(:iTotalRecords) { Video.count }
node(:iTotalDisplayRecords) { @videos.count }
node(:aaData) do
  @videos.map do |video|
    [
      link_to(video.name, video),
      video.formated_air_date,
      video.file_hash
    ]
  end
end
