ItemView = require './item_view'
ShowView = require './show_view'
AddView = require './add_view'
EditView = require './edit_view'

module.exports = class ListView extends Backbone.View

  events:
    'click button.add-button': 'add'

  initialize: (options) ->
    @templates = options.templates
    @listenTo @collection, 'error', @errorHandler
    @listenToOnce @collection, 'sync', @showRecentItem
    @listenTo @collection, 'add', @renderItem
    @listenTo @collection, 'remove', @showRecentItem

    @listenTo @collection, 'model:show', @showItem
    @listenTo @collection, 'model:edit', @editItem
    @listenTo @collection, 'model:copy', @copyItem
    @listenTo @collection, 'model:add', @addItem
    @listenTo @collection, 'model:select', @selectItem

  render: ->
    @$el.html @templates.list()
    @$list = @$('.list-area')

    this

  renderItem: (model) ->
    item_view = new ItemView {model, template: @templates.item}
    @$list.append item_view.render().el

  add: ->
    @collection.trigger 'model:add'

  showRecentItem: ->
    model = @collection.get @collection.selected
    model or= @collection.first()
    model and @showItem model

  errorHandler: (modelOrCollection, resp, options) ->
    console.log resp
    console.log options
    alert resp.responseText

  showItem: (model) ->
    @collection.selected = model.id
    model.trigger 'model:selected'
    @show_view = new ShowView {model, template: @templates.show}
    @$('.show-add-edit-area').html @show_view.render().el
    @trigger 'view:show', @show_view

  addItem: ->
    model = @collection.add name: '_'
    model.trigger 'model:selected'
    @add_view = new AddView {model, template: @templates.add}
    @$('.show-add-edit-area').html @add_view.render().el
    @trigger 'view:add', @add_view

  editItem: (model) ->
    @edit_view = new EditView {model, template: @templates.edit}
    @$('.show-add-edit-area').html @edit_view.render().el
    @trigger 'view:edit', @edit_view

  copyItem: (json) ->
    model = @collection.add json
    model.trigger 'model:selected'
    @editItem model

  createByName: (row, callback) ->
    url = @collection.url()
    $
    .get url, name: row.name
    .done (results) =>
      return callback() if results.length
      success = (model) ->
        model.trigger 'model:created', model
        callback()
      @collection.create row, wait: true, wait: true, success: success
