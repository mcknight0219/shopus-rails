# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Express extends Backbone.Model

class ExpressList extends Backbone.Collection
  model: Express
  url: '/express'

  parse: (response) =>
    response.express
    
  initialize: ->
    @fetch
      reset: true
      
expresses = new ExpressList

