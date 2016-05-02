class ImageCell extends Backbone.Model
  STATES: ['progress', 'failure', 'success']
  defaults:
    state: 'progress'
    percentage: 0

  initialize: ->
    # Begin uploading upon creating
    $.ajax

  inProgress: ->
    @get('state') == 'progress'

  inFailure: ->
    @get('state') == 'failure'

class ImageCells extends Backbone.Collection

  model: ImageCell


class ImageCellView extends Backbone.View
  tagName: "li"

  template: _.template("<div class=\"weui_uploader_status_content\"><%= status %></div>")

  className: "weui_uploader_file weui_uploader_status"

  initialize: ->
    @model.bind('change:state', @render)

  setBg: (src) =>
    @$el.attr('style', "background-image:url(#{src})")

  remove: ->
    @$el.remove()

  render: =>
    content = switch
      when @model.inProgress() then "#{@model.get('percentage')}"
      when @model.inFailure()  then "<i class=weui_icon_warn></i>"
      else ""

    @$el.html(@template({status: content}))
    @


class ImageCellsView extends Backbone.View
  el: 'div .weui_uploader_files'

  events:
    "click input[type=\"file\"]" :    "resetFile"
    "change input[type=\"file\"]":    "addFile",
    "click li" : "prompt",
    "click .weui_btn_dialog.primary": "confirmDelete",
    "click .weui_btn_dialog.default": "dismissDialog"

  dlgTpl: _.template( $('#delete_image_dialog').html() )

  initialize: ->
    console.log 'Loaded'
    @subviews = []
    @images    = new ImageCells
    @images.bind('add',   @createView)
    @images.bind('remove',@removeView)

  # Trick the browser to let us upload same file again
  resetFile: (e) ->
    $(e.target).val('')

  addFile: (e) ->
    file = _.last e.target.files
    @images.add( {file: file} )
    @changeCount()

  createView: (e) =>
    cellView = new ImageCellView( {model: e} )
    @subviews.push cellView
    reader = new FileReader
    reader.onload = (e) =>
      (_.last @subviews).setBg e.target.result
    reader.readAsDataURL e.get('file')

    @$('ul').append(cellView.render().el)

  removeView: (e) =>
    _.map @subviews, (v) =>
      v.remove() if e is v.model

  prompt: (e) =>
    e.stopPropagation()
    @toDelete = @images.at $(e.target).index()
    # Materialize the dialog
    @$el.append(@dlgTpl())

  dismissDialog: =>
    @$('.weui_dialog_alert').remove()

  confirmDelete: =>
    if @toDelete?
      @images.remove @toDelete
      @changeCount()
    @dismissDialog()

  changeCount: ->
    count = @images.length
    $('#upload_counter').html("#{count}/6")

window._commentView = new CommentView
window._uploadView  = new ImageCellsView
