object false
node(:draw) { params[:draw].to_i }
node(:recordsTotal) { Video.count }
node(:recordsFiltered) { Video.count }
node(:data) do
  @videos.map do |video|
    [
      link_to(video.name, video),
      video.formated_air_date,
      video.file_hash
    ]
  end
end
