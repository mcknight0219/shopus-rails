# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Express extends Backbone.Model
  url: '/express'

class ExpressView extends Backbone.View
  tagName: "div"
  template: _.template('<div class="weui_cell"><div class="weui_cell_hd"><img src=<%= url %> style="width:40px;margin-right:5px;diplay:block"></div><div class="weui_cell_hd weui_cell_primary"><%= company %></div><div class="weui_cell_ft"></div></div>')
  className: "weui_cell"

  events:
    "click .weui_cell":   "toggleDetails"

  initialize: ->
    @editor = new EditorView(@model)
  
  toggleDetails: (e) ->
    @editor.toggle()

  render: =>
    $('#express_list').append @template({company: @model.get('company'), url: @model.get('url')})
 
class ExpressList extends Backbone.Collection
  model: Express
  url: '/express'

  comparator: 'company'

  parse: (response) =>
    response.express
    
  initialize: ->
    @fetch {reset: true}

class ExpressListView extends Backbone.View
  li: '#express_list'
  
  initialize: ->
    @subviews = []
    @list = new ExpressList
    @list.bind('reset', 'addSubviews')

  addSubviews: =>
    @list.each (m) =>
      ev = new ExpressView {model: m}
      @subviews.push ev
      @el.append ev.render().el
    


class EditorView extends Backbone.View
  tagName: "div"
  className: 'weui_cells weui_cells_form'
  template: _.template("""
    <div class="weui_cell">
      <div class="weui_cell_hd">
        <label class="weui_label">Company</label>
      </div>
      <div class="div weui_cell_hd weui_cell_primary"><input class="weui_input" type="text" placeholder=<%= company %>></div>
    </div>
    
    <div class="weui_cell weui_cell_select weui_cell_select_after">
      <div class="weui_cell_hd"><label class="weui_label">Country</label></div>
      <div class="weui_cell_bd weui_cell_primary">
        <select class="weui_select">
          <option value="Canada">加拿大</option>
          <option value="USA">美国</option>
          <option value="China">中国</option>
        </select>
      </div>
    </div>

    <div class="weui_cell weui_cell_select weui_cell_select_before">
      <div class="weui_cell_hd"><select id="" class="weui_select">
          <option value="1">kg</option>
          <option value="2">lb</option>
          <option value="3">article</option>
        </select>
      </div>
      <div class="weui_cell_bd weui_cell_primary"><input class="weui_input" type="number" placeholder=<%= rate %>></div>
    </div>

    <div class="weui_cell weui_cell_select weui_cell_select_after">
      <div class="weui_cell_hd"><label class="weui_label" for="">EAT</label></div>
      <div class="weui_cell_bd weui_cell_primary">
        <select class="weui_select">
          <option value="1">One week</option>
          <option value="2">Two weeks</option>
          <option value="3">One month</option>
        </select>
      </div>
    </div>

    <div class="weui_btn_area"><a class="weui_btn weui_btn_primary">Update</a></div>
    """)

  events:
    "click a.weui_btn" : "update"

  initialize: ->
    @hide = true
    @$el.hide()

  toggle: =>
    switch @hide
      when true then @$el.show()
      else @$el.hide()

    @hide = !@hide

  update: ->
    @model.save({patch: true})

  render: ->
    @$el.html( @template(@model) )
    @
