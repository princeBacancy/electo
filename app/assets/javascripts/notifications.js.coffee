class Notifications
console.log("hello") 
  constructor: ->
    @notifications = $("[data-behaviour='notifications']")
    @setup() if @notifications.length > 0
  
  setup: ->
    console.log("hello") 

jQuery -> 
  debugger
  new Notifications