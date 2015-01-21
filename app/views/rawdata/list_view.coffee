ItemView = require './item_view'

module.exports = class ListView extends Backbone.View

  template: require './templates/list'

  events:
    'click button.reset-rawdatas': 'resetCollection'

  initialize: ->
    @listenTo @collection, 'add', @renderItem

  render: ->
    @$el.html @template()
    @$list = @$('.rawdata-list-area')

    this

  renderItem: (model) ->
    item_view = new ItemView {model}
    @$list.append item_view.render().el

  resetCollection: ->
    @collection.remove @collection.models
