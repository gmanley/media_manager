$ ->
  $('.snapshots').responsiveSlides(
    maxwidth: 800
    auto: false
    pager: true
    customPager: true
    speed: 300
  )

  $('#videos_table').dataTable(
    sPaginationType: 'bootstrap'
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#videos_table').data('source')
  )