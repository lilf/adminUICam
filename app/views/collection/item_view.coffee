module.exports = class ItemView extends Backbone.View

  tagName: 'li'

  events:
    'click': 'show'

  initialize: (options) ->
    @template = options.template
    @listenTo @model, 'change', @render
    @listenTo @model, 'remove', @remove
    @listenTo @model, 'model:selected', @selected

  render: ->
    @$el.html @template @model.toJSON()

    this

  show: ->
    @selected()
    @model.trigger 'model:show', @model

  selected: ->
    @$el.siblings('.uk-active').removeClass 'uk-active'
    @$el.addClass 'uk-active'
