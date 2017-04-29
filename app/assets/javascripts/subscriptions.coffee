# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:fetch', ->
  $('.spinner').show()
  return
$(document).on 'page:change', ->
  $('.spinner').hide()
  return
$(document).ready ->
  $('.spinner').hide()
  return
