module.exports = class ItemView extends Backbone.View

  template: require './templates/item'

  tagName: 'tr'

  render: ->
    json = @model.toJSON()
    @$el.html @template json

    this
