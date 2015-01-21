ItemView  = require './item_view'

module.exports = class ListView extends Backbone.View

  template: require './templates/list'

  events:
    'click button.save-button': 'save'
    'click button.fallback-button': 'fallback'
    'click button.reset-button': 'reset'
    'sortable-stop .uk-sortable': 'sort'

  initialize: ->
    @listenTo @collection, 'add', @renderItem

  render: ->
    @$el.html @template()
    @$list = @$('tbody')

    this

  renderItem: (model) ->
    item_view = new ItemView {model}
    @$list.append item_view.render().el

  renderThead: (columns) ->
    @columns = columns
    @_renderThead columns
    @_renderTheadForReorder columns

  _renderThead: (columns) ->
    html = _.map columns, (column) -> $ '<th>', text: column
    html.push $ '<th>'
    @$('thead tr:first').html html

  _renderTheadForReorder: (columns) ->
    html = _.map columns, (column, i) -> $ '<th>', text: i, class: 'order-handler'
    html.push $ '<th>', html: '<i class="uk-icon-hand-o-left"></i><span>&nbsp;reorder</span>'
    @$('thead tr:last')
    .html html
    .hide()

  fallback: ->
    model = @collection.getOld()
    return unless model
    model.once 'destroy', @fallback, this
    model.destroy wait: true

  save: ->
    model = @collection.getNew()
    return unless model
    model.once 'sync', @save, this
    model.save {}, wait: true

  reset: ->
    @collection.remove @collection.models

  sort: (e) ->
    indexes = $(e.target).children('.order-handler').map -> +$(this).text()
    @trigger 'column:order:changed', indexes
