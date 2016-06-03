
class Express extends Backbone.Model
  url: '/express'

  name: ->
    denormalize @get('company')

  save: (attrs, options) =>
    console.log @changedAttributes()
    # $.ajax "/express/#{@get('id')}",
    #   type: 'PATCH'
    #   beforeSend: (xhr) =>
    #     xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
    #   contentType: 'application/json'
    #   data: @toJSON()
    #   success: (xhr, status, error)=>
    #     @set('state', 'success')
    #   error: (xhr, status, error) =>
    #     @set('state', 'failure')
  
 
class ExpressView extends Backbone.View
  tagName: "div"
  template: _.template("""
      <h4 class="weui_media_title"><%= company %></h4>
      <p class="weui_media_desc"><%= desc %></p>
      <ul class="weui_media_info">
        <li class="weui_media_info_meta"><%= price %></li>
        <li class="weui_media_info_meta"><%= timestamp %></li>
        <li class="weui_media_info_meta weui_media_info_meta_extra"><%= eta %></li>
      </ul>
    """)

  className: 'weui_media_box weui_media_text'

  events:
    "click":   "showEditorModal"

  initialize: ->
    @desc = @model.get('description')
    @price = "#{@model.get('rate')} / #{@model.get('unit')}"
    @timestamp = @model.get('created_at')
    @eta = @model.get('duration')

  showEditorModal: (e) ->
    editor = new EditorModal({model: @model})
    editor.render()

  render: =>
    @$el.append(@template({company: @model.name(name), desc: @desc, price: @price, timestamp: @timestamp, eta: @eta}))
    @
 
class ExpressList extends Backbone.Collection
  model: Express
  url: '/express'

  parse: (response) =>
    response.express
    
  initialize: ->
    @fetch({reset: true})

class ExpressListView extends Backbone.View
  el: '#express_list'
  
  initialize: =>
    @subviews = []
    @list = new ExpressList
    @list.bind('reset', @addSubviews)
    @list.bind('destroy', @refreshSubviews)

  addSubviews: =>
    @list.each (m) =>
      ev = new ExpressView {model: m}
      @subviews.push ev
      @$el.append(ev.render().el)

  refreshSubviews: (model, collection)=>
    console.log 'A model is deleted'

class EditorModal extends Backbone.View
  el: '#editor_modal'

  dlgTpl: _.template($('#editor_dialog_template').html())
  
  events:
    "click a.weui_btn_dialog.default" : "cancel",
    "click a.weui_btn_dialog.primary" : "save",
    "click a#delete_link": "delete"

  cancel: ->
    @$el.empty()

  save: ->
    @model.set('unit',    @$('#unit_option').val())
      .set('rate',    @$('#rate_field').val())
      .set('duration',@$('#time_option').val())
      .save({patch: true})
    @cancel()

  delete: =>
    @actionSheet = new ActionSheet({model: @model})
    @actionSheet.render()

  setVals: ->
    @$('.weui_dialog_title').html("Edit #{@model.name()}")
    @$('#rate_field').attr('placeholder', @model.get('rate'))
    @$('#unit_option > option').each (i, e) =>
      if e.text is @model.get('unit')
        @$('#unit_option').val(e.value)

    @$('#time_option > option').each (i, e) =>
      if e.text is @model.get('duration')
        @$('#time_option').val(e.value)

  render: =>
    @$el.html(@dlgTpl())
    @setVals()
    @

class ActionSheet extends Backbone.View
  el: '#action_sheet'

  sheetTpl: _.template($('#delete_action_sheet_template').html())

  events:
    'click #actionsheet_delete': 'delete',
    'click #actionsheet_cancel': 'cancel'

  cancel: ->
    @fadeOut()

  delete: ->
    console.log @model.get('id')
    @model.destroy()

  fadeIn: ->
    mask = @$('#mask')
    @$('#weui_actionsheet').addClass('weui_actionsheet_toggle')
    @$('#mask').show().focus().addClass('weui_fade_toggle')

  fadeOut: ->
    @$('#weui_actionsheet').removeClass('weui_actionsheet_toggle')
    @$('#mask').removeClass('weui_fade_toggle')
    @$('#mask').on('transitionend', ()->
      $('#mask').hide()
    ).on('webkitTransitionEnd', ()->
      $('#mask').hide()
    )

  render: =>
    @$el.html(@sheetTpl())
    @fadeIn()


oldSync = Backbone.sync
Backbone.sync = (method, model, options) ->
  options.beforeSend = (xhr) ->
    xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
  oldSync(method, model, options)

window.normalize = (s) ->
    s.toLowerCase().replace ' ', '_'

window.denormalize = (s) ->
    _.map(s.split('_'), (w) ->
      w.charAt(0).toUpperCase() + w.slice(1)
    ).join(' ')

window._expressMethodsList = new ExpressListView
