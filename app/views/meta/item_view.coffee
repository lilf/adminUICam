module.exports = class ItemView extends Backbone.View

  template: require './templates/item'

  tagName: 'li'

  className: 'uk-nestable-list-item'

  events:
    'click button.move-to-top-button': 'moveTop'

  initialize: ->
    @listenTo @model, 'remove', @remove
    @listenTo @model, 'save:order', @saveOrder

  render: ->
    @$el.html @template @model.toJSON()

    this

  moveTop: ->
    @$el.after @$el.siblings('li')

  saveOrder: (callback) ->
    data = order: @$el.index()
    order = @model.get 'order'
    return callback() if order is data.order
    @model.save data, success: callback
