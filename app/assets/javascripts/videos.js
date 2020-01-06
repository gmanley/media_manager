$(document).on('ready turbolinks:load', function() {
  $('.snapshots').responsiveSlides({
    maxwidth: 800,
    auto: false,
    pager: true,
    // customPager: true,
    manualControls: '.rslides_tabs',
    speed: 300
  });

  $('#videos_table').dataTable({
    pagingType: 'full_numbers',
    processing: true,
    serverSide: true,
    ajax: $('#videos_table').data('source')
  });
});
