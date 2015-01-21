ItemView  = require './item_view'

module.exports = class ListView extends Backbone.View

  template: require './templates/list'

  initialize: ->
    @listenTo @collection, 'add', @renderItem
    @listenTo @collection, 'searched', @showResultInfo

  render: ->
    @$el.html @template()
    @$list = @$ 'tbody'

    this

  renderItem: (model) ->
    item_view = new ItemView {model}
    @$list.append item_view.render().el

  showResultInfo: ->
    @$('h3[name=count]').text @collection.length + ' Found'
