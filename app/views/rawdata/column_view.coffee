_ColumnView = require './item_column_view'

module.exports = class ColumnView extends Backbone.View

  template: require './templates/column'

  events:
    'click button.search-button': 'search'

  initialize: ->
    @listenTo @collection, 'add', @renderItem

  render: ->
    @$el.html @template()
    @$list = @$('.column-list')

    this

  renderItem: (model) ->
    _column_view = new _ColumnView {model}
    @$list.append _column_view.render().el

  search: ->
    json = @$el.toObject()
    return if _.isEmpty json
    @trigger 'view:search', json
