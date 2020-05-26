object false
node(:draw) { params[:draw].to_i }
node(:recordsTotal) { Video.count }
node(:recordsFiltered) { @videos.total_count }
node(:data) do
  @videos.map do |video|
    [
      link_to(video.name, video_path(video.id)),
      video.formated_air_date,
      video.file_hash,
      video.external_id
    ]
  end
end
