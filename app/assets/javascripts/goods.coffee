
class Comment
  MAX_CHARS: 20
  constructor: (content = "") ->
    @content = content

  count: ->
    @content.length

  remaining: ->
    Comment::MAX_CHARS - @count()


class Image extends Backbone.Model
  initialize ->

  clear: ->
    @destroy()
    @view.remove()


class Images extends Backbone.Collection
  defaults:
    images: []

  model: Image

  add: (m)->
    @save({images: @get("images").push(m)})

  delete: (m)->
    @remove m
    m.clear()

class ImageView extends Backbone.View
  el: ".weui_uploader"


  

class GoodsView extends Backbone.View
  el: ".container"
  currentComment: new Comment
  currentImages:  new Images

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

  addFile: (e)->
    @currentImages.add e.files[0]

  updateImageList: ->
    true



window._goodsView = new GoodsView
