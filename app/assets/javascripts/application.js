//= require rails-ujs
//= require jquery
//= require turbolinks
//= require bootstrap-alert
//= require bootstrap-dropdown
//= require bootstrap-transition
//= require bootstrap-button
//= require bootstrap-collapse
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
