module.exports = class ItemView extends Backbone.View

  tagName: 'tr'

  events:
    'click button.destroy-button': 'destroy'

  initialize: (options) ->
    @template = options.template
    @listenTo @model, 'remove', @remove
    @listenTo @model, 'model:show', @show
    @listenTo @model, 'model:hide', @hide

  render: ->
    @$el.html @template @model.toJSON()
    # @$el.attr 'data-order1', @model.get('order1') or 'undefined'
    # @$el.attr 'data-order2', @model.get('order2') or 'undefined'

    this

  destroy: ->
    return unless confirm 'sure to delete?'
    @model.destroy wait: true

  show: ->
    @$el.show()

  hide: ->
    @$el.hide()
