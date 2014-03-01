#= require libraries
#= require utils
#= require_self
#= require loading-indicator
#= require videos

window.App = {}

$ ->
  $('.alert').delay(4000).fadeOut('slow')
  $('.chosen').chosen()

# Have a loading screen when turbolinks is working it's magic
document.addEventListener 'page:fetch', ->
  App.LoadingIndicator.show()

document.addEventListener 'page:receive', ->
  App.LoadingIndicator.hide()
