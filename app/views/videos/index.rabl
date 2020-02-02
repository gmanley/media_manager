object false
node(:draw) { params[:draw].to_i }
node(:recordsTotal) { Video.count }
node(:recordsFiltered) { @video_count }
node(:data) do
  @videos.map do |video|
    [
      link_to(video.name, "/videos/#{video.id}"),
      video.formated_air_date,
      video.file_hash,
      video.csv_number
    ]
  end
end
