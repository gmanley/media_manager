$(document).on('ready turbolinks:load', function() {
  $('.snapshots').responsiveSlides({
    maxwidth: 750,
    auto: false,
    pager: true,
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
