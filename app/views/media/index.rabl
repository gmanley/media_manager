object false
node(:sEcho) { params[:sEcho].to_i }
node(:iTotalRecords) { Media.count }
node(:iTotalDisplayRecords) { @media.total_count }
node(:aaData) do
  @media.map do |media|
    [
      link_to(media.name, media),
      media.formated_air_date,
      media.formated_duration
    ]
  end
end