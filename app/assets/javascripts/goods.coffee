class ImageCell extends Backbone.Model
  STATES: ['progress', 'failure', 'success']

  initialize: ->
    @state = 'progress'
    # nothing uploaded yet
    @percentage = 0

  inProgress: ->
    @state === 'progress'

  inFailure: ->
    @state === 'failure'

  clear: ->
    @destroy()
    @view.remove()


class ImageCellView extends Backbone.View
  tagName: "li"
  template: _.template("<div class=\"weui_uploader_status_content\"><%= status %></div>")
  className: "weui_uploader_file weui_uploader_status"

  events:
    "click": "showDialog"

  attributes: ->
    'style': "background-image:url(http://shp.qpic.cn/weixinsrc_pic/pScBR7sbqjOBJomcuvVJ6iacVrbMJaoJZkFUIq4nzQZUIqzTKziam7ibg/)"

  initialize: ->
    @model.bind('change:state', @render)

  render: ->
    content = switch
      when @model.inProgress then "#{@model.get('percentage')}"
      when @model.inFailure  then "<i class=weui_icon_warn></i>"
      else ""

    content.length ?
      $el.html(@template(status: content)) :
      $el

  # Ask user if they want to remove this image
  showDialog: ->


class DialogView extends Backbone.View
  tempalte: _.template($('#image_uploader_dialog').html())

  events:
    "click "


# Image uploading goes to a different set of endpoint so
# multiple images could be uloaded asynchronously while
# the user is still working on other parts of the page.
# And it also allows better visual experience.
class ImageCells extends Backbone.Collection
  defaults:
    cells: []

  model: ImageCell

class Comment
  MAX_CHARS: 200
  constructor: (content = "") ->
    @content = content

  count: ->
    @content.length

  remaining: ->
    Comment::MAX_CHARS - @count()


class GoodsView extends Backbone.View
  el: ".container"
  currentComment: new Comment

  events:
    "keyup textarea":               "updateComment",
    "change input[type=\"file\"]":  "addFile"

  initialize: ->
    @currentImages.bind('change', updateImageList)
    @updateCommentCounter(0)

  updateComment: (e) ->
    target = $(e.currentTarget)
    @currentComment = new Comment(target.val())
    if @currentComment.remaining() < 0
      target.val(target.val().substr(0, Comment::MAX_CHARS))
      return
    @updateCommentCounter(@currentComment.count())


  updateCommentCounter: (newCount) ->
    if newCount < Comment::MAX_CHARS
      $('.weui_textarea_counter > span').text("#{newCount}/#{Comment::MAX_CHARS}")
    else
      $('.weui_textarea_counter > span').html("<i style=\"color:red;\">#{newCount}</i>/#{Comment::MAX_CHARS}")


window._imageCellsView = new ImageCellView
window._goodsView = new GoodsView
