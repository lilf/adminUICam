ItemView = require './item_view'

module.exports = class ListView extends Backbone.View

  template: require './templates/list'

  initialize: ->
    @listenTo @collection, 'add', @renderItem

  render: ->
    @$el.html @template()
    @$list = @$ 'ul'

    this

  renderItem: (model) ->
    item_view = new ItemView {model}
    @$list.append item_view.render().el

  removeEmptyItem: ->
    @$('.uk-nestable-empty').remove()
