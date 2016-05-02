# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class ExpressView extends Backbone.View
  el: 'form'

  events:
    'click input[type="radio"]': 'toggleExpress'

  initialize: ->
    @

  toggleExpress: (e) ->
    element = e.target
    _.map @$('input["radio"]'), (i) =>
      i.attr('checked', '')
    $(element).attr('checked', 'checked')

window._expressView = new ExpressView
