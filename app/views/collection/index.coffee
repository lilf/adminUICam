Categories = require 'models/categories'
ListView = require './list_view'

module.exports = class PageNode extends Backbone.Node

  defines:
    categories: 'categories'

  requires:
    rawdatas: 'rawdatas'
    columns: 'columns'
    
  initialize: ->
    @collection = new Categories
    @list_view = new ListView {@collection}

    @listenTo @list_view, 'view:show', @showView
    @listenTo @list_view, 'view:add', @addView
    @listenTo @list_view, 'view:edit', @editView

    $('#category').html @list_view.render().el

    @collection.fetch()

  showView: (view) ->
    parent = @collection
    .get view.model.get 'parent_id'
    
    return unless parent

    view
    .$ 'dd:last'
    .text parent.get 'name'

  addView: (view) ->
    view
    .$('select[name=parent_id]')
    .html @renderOptions view.model

  editView: (view) ->
    view
    .$('select[name=parent_id]')
    .html @renderOptions view.model
    .val view.model.get('parent_id')

  renderOptions: (model) ->
    array = @collection.without(model).map (item)  -> item.toJSON()
    array.unshift _id: 'null', name: 'please choose a parent category'
    array.map (json) -> $ '<option>', value: json._id, text: json.name
