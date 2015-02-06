# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class window.EventsFeed
  start: (pollingInterval, refreshLink)->
    window.setTimeout (->
      console.log('refreshing...')
      $("#{refreshLink}")[0].click()
      return
    ), pollingInterval
