# 开始手撸coffeescript

class @Product
  constructor: ->
    @files = []
    @altertor = $('.weui_dialog_alert')
    @altertor.hide()
    $('.weui_btn_dialog.primary').click(() =>
      @altertor.hide()
    )

  populate_from_form: ->
    @name     = $('input#name')
    @brand    = $('input#brand')
    @currency = ['CAD', 'USD', 'CNY'][$('select#currency')-1]
    @sanitize()

  sanitize: ->
    false

  create: ->

  description_text_count: ->
    $('textarea').val().length

  uploaded_file_count: ->
    @files.length

  alert_error: ->
    @altertor.show()
