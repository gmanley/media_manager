$ ->
  $('.snapshots').responsiveSlides(
    maxwidth: 800
    auto: false
    pager: true
    customPager: true
    speed: 300
  )

  $('.sortable').tablesorter(sortList: [[0,0]])

  $('th.tablesorter-header').on('click', (e) ->
    $(this).siblings().find('i[class|="icon"]').removeClass()
    if $(this).hasClass('tablesorter-headerSortUp')
      $(this).find('i').attr('class', 'icon-arrow-up')
    else if $(this).hasClass('tablesorter-headerSortDown')
      $(this).find('i').attr('class', 'icon-arrow-down')
  )