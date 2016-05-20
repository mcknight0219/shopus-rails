
class Express extends Backbone.Model
  url: '/express'

  name: ->
    denormalize @get('company')
  
class ExpressView extends Backbone.View
  tagName: "a"
  template: _.template('<div class="weui_cell_hd"><img src="" style="width:27px;margin-right:5px;diplay:block"></div><div class="weui_cell_hd weui_cell_primary"><%= company %></div><div class="weui_cell_ft"></div>')
  className: "weui_cell"

  events:
    "click":   "showEditorModal"

  initialize: =>
    @fetchLogo()

  fetchLogo: ->
    $.ajax "/logo/#{normalize @model.get('company')}",
      success: (data, textStatus, xhr) =>
        unless data.type is undefined
          @$('img').attr('src', data.data)


  showEditorModal: (e) ->
    editor.render()

  render: =>
    @$el.html(@template({company: @model.name()}))
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

  addSubviews: =>
    @list.each (m) =>
      ev = new ExpressView {model: m}
      @subviews.push ev
      @$el.append(ev.render().el)

class EditorModal extends Backbone.View
  dlgTpl: _.template($('#editor_dialog_template').html())
  
  events:
    "click a.weui_btn_dialog.default" : "cancel",
    "click a.weui_btn_dialog.primary" : "save"

  initialize: ->

  cancel: ->
    @$('#editor_dialog').remove()

  save: ->
    @model.set('company', normalize @$('#company_field').val())
    @model.set('country', @$('#country_option').val())
    @model.set('unit',    @$('#unit_option').val())
    @model.set('rate',    @$('#rate_field').val())
    @model.set('duration',@$('#time_option').val())
    @model.save({patch: true})

    @cancel

  populateDefaultValues: ->
    

  render: =>
    $('.container').append(@dlgTpl())
    @populateDefaultValues()
    @

window.normalize = (s) ->
    s.toLowerCase().replace ' ', '_'

window.denormalize = (s) ->
    _.map(s.split('_'), (w) ->
      w.charAt(0).toUpperCase() + w.slice(1)
    ).join(' ')

editor = new EditorModal
window._expressMethodsList = new ExpressListView
