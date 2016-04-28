class ImageCell extends Backbone.Model
  STATES: ['progress', 'failure', 'success']

  initialize: ->
    @state = 'progress'
    # nothing uploaded yet
    @percentage = 0

  inProgress: ->
    @state is 'progress'

  inFailure: ->
    @state is 'failure'

class ImageCells extends Backbone.Collection

  model: ImageCell


class DialogView extends Backbone.View
  template: _.template($('#image_uploader_dialog').html())

  events:
    "click .weui_btn_dialog.default": "hide",
    "click .weui_btn_dialog.primary": "confirm"

  initialize: (@parent) ->
    @hide()

  hide: ->
    $el.hide()

  confirm: ->
    @hide()

class ImageCellView extends Backbone.View
  tagName: "li"

  template: _.template("<div class=\"weui_uploader_status_content\"><%= status %></div>")

  className: "weui_uploader_file weui_uploader_status"

  events:
    "click": "showDialog"

  initialize: ->
    @model.bind('change:state', @render)

  setBg: (src) =>
    @$el.attr('style', "background-image:url(#{src})")

  render: =>
    content = switch
      when @model.inProgress() then "#{@model.get('percentage')}"
      when @model.inFailure()  then "<i class=weui_icon_warn></i>"
      else ""

    @$el.html(@template({status: '12'}))
    this

class ImageCellsView extends Backbone.View
  el: 'div .weui_uploader_files'

  events:
    "change input[type=\"file\"]":  "addFile"

  initialize: ->
    @images   = new ImageCells
    @subviews = []
    @images.bind('add',   @createView)
    @images.bind('remove',@removeView)

  addFile: (e) ->
    file = _.last e.target.files
    @images.add( {file: file} )

  createView: (e) =>
    @subviews.push(new ImageCellView( {model: e} ))
    reader = new FileReader
    reader.onload = (e) =>
      (_.last @subviews).setBg e.target.result
    reader.readAsDataURL e.get('file')
    # Get the wheel rolling
    e.set('state', 'failure')
    @render()

  removeView: (e) =>
    _.reject @subviews, (v) => e is v.model
    @render()

  render: =>
    _.map @subviews, (v) =>
      @$('ul').append(v.render().el)
    this

window._commentView = new CommentView
window._uploadView  = new ImageCellsView
