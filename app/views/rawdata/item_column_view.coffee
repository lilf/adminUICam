module.exports = class _ColumnView extends Backbone.View

  template: require './templates/item_column'

  render: ->
    @$el.html @template @model.toJSON()

    this
