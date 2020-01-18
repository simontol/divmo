# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).on "ready page:change", ->
  $("[data-toggle='tooltip']").tooltip("destroy").tooltip()
  return

$(document).on 'page:fetch', ->
  $('#content').fadeOut 'slow'

$(document).on 'page:restore', ->
  $('#content').fadeIn 'slow'