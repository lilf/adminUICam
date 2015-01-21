module.exports = class MetaView extends Backbone.View

  template: require './templates/meta'

  events:
    'change select[name=table]': 'changeTable'
    'click button.save-order-button': 'saveOrder'

  render: ->
    @$el.html @template()

    this

  changeTable: (e) ->
    table = e.target.value
    return if table is ''
    @trigger 'change:table', table

  saveOrder: ->
    return unless confirm 'sure to reorder?'
    @trigger 'save:order'
