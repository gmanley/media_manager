//= require rails-ujs
//= require jquery3
//= require turbolinks
//= require bootstrap-sprockets
//= require chosen.jquery
//= require responsiveslides
//= require utils
//= require datatables
//= require_self
//= require videos

window.App = {};

$(document).on('ready turbolinks:load', function() {
  $('.alert').delay(4000).fadeOut('slow');
  $('.chosen').chosen();
});
