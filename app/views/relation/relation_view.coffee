ItemView = require './item_view'

module.exports = class RelationView extends Backbone.View

  template: require './templates/relation'

  events:
    'click button.create-button': 'create'
    'click button.query-button': 'query'

  initialize: (options) ->
    @templates = options.templates
    @listenTo @collection, 'add', @renderItem
    @listenTo @collection, 'error', @errorHandler

  render: ->
    @$el.html @templates.relation()
    @$("[data-uk-margin]").ukMargin()
    @$list = @$('tbody.raw-table')

    this

  renderItem: (model) ->
    item_view = new ItemView {model, template: @templates.item}
    @$list.append item_view.render().el
    @sortItem()

  sortItem: ->
    @$list.children().tsort 'td.order1', 'td.order2'

  errorHandler: (modelOrCollection, resp, options) ->
    console.log resp
    console.log options
    alert resp.responseText

  create: ->
    json = @$('.uk-form').toObject()
    @checkExist json, (data, jqXHR) =>
      if data.length
        alert 'alreay exist or param required'
      else
        @collection.create json, wait: true

  checkExist: (json, success) ->
    $.ajax
      url: @collection.url()
      data: json
      success: success
      error: (jqXHR) -> alert 'could not connect to server'

  query: ->
    json = @$('.uk-form').toObject()
    selected = @collection.where json
    unselected = @collection.without selected...

    if _.isEmpty json
      selected = unselected
      unselected = []

    _.each selected, (model) -> model.trigger 'model:show'
    _.each unselected, (model) -> model.trigger 'model:hide'
