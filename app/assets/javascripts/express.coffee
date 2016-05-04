class ExpressView extends Backbone.View
  el: 'body'

  events:
    'click .weui_btn_dialog.primary': 'removeDialog'

  toastTpl: _.template($('#toast_template').html())
  dlgTpl:   _.template($('#dialog_template').html())

  initialize: ->
    mode = switch @mode()
      when 'success' then @toast()
      when 'failure' then @triggerDialog()
    @

  mode: ->
    pattern = /\?mode=(success|failure)/i
    (window.location.search.match pattern)?[1]

  toast: ->
    @$el.append @toastTpl()
    window.setTimeout(@removeToast, 2000)

  # Failure requires user's more attention
  triggerDialog: ->
    @$el.append @dlgTpl()
    
     
  removeToast: () =>
    $('#toast').remove()

  removeDialog: () =>
    $('#dialog').remove()

window._expressView = new ExpressView
