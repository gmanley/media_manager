$ ->
  $('.snapshots').responsiveSlides(
    maxwidth: 800
    auto: false
    pager: true
    customPager: true
    speed: 300
  )

  $('#media_table').dataTable(
    sPaginationType: 'bootstrap'
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#media_table').data('source')
  )