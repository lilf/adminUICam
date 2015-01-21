module.exports = class LinkView extends Backbone.View

  template: require './templates/link'

  tagName: 'li'

  initialize: ->
    @listenTo @model, 'model:active', @active

  events:
    'click': 'active'

  render: ->
    @$el.html @template @model.toJSON()

    this

  active: ->
    @$el
    .addClass 'uk-active'
    .siblings '.uk-active'
    .removeClass 'uk-active'
