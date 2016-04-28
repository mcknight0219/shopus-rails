class Comment
  MAX_CHARS: 200
  constructor: (content = "") ->
    @content = content

  count: ->
    @content.length

  remaining: ->
    Comment::MAX_CHARS - @count()


class @CommentView extends Backbone.View
  el: "#good_comment_textarea"
  comment: new Comment

  events:
    "keyup .weui_textarea": "updateComment"

  initialize: ->
    @updateCommentCounter(0)

  updateComment: (e) ->
    target = $(e.currentTarget)
    @comment = new Comment(target.val())
    if @comment.remaining() < 0
      target.val(target.val().substr(0, Comment::MAX_CHARS))
      return
    @updateCommentCounter(@comment.count())


  updateCommentCounter: (newCount) ->
    if newCount < Comment::MAX_CHARS
      $('.weui_textarea_counter > span').text("#{newCount}/#{Comment::MAX_CHARS}")
    else
      $('.weui_textarea_counter > span').html("<i style=\"color:red;\">#{newCount}</i>/#{Comment::MAX_CHARS}")
