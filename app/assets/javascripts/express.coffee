class ExpressView extends Backbone.View
  el: 'body'

  dlgTpl: _.template( $('#alert_user_dialog').html() )

  initialize: ->
    switch @mode()
      when 'success' then @alert_user
      when 'failure' then @alert_user true

    @

  mode: ->
    pattern = /\?mode=(success|failure)/i
    (window.location.search.match pattern)?[1]

  alert_user: (bad = false) ->


  window._expressView = new ExpressView
