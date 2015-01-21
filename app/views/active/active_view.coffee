TaskView = require './task_view'

module.exports = class ActiveView extends Backbone.View

  template: require './templates/active'

  events:
    'click button.active-all-button': 'active'

  initialize: ->
    @listenTo @collection, 'add', @renderItem

  render: ->
    @$el.html @template()
    @$list = @$('tbody')

    this

  renderItem: (model) ->
    task_view = new TaskView {model}
    @$list.append task_view.render().el

  fetch: ->
    model = @getUnFetched()
    return unless model
    @listenToOnce model, 'change:fetched', @fetch, this
    setTimeout (-> model.trigger 'model:fetch'), 1000

  getUnFetched: ->
    models = @collection.where fetched: false
    models[0]

  active: ->
    model = @getUnActiveed()
    return unless model
    @listenToOnce model, 'change:actived', @active, this
    setTimeout (-> model.trigger 'model:active'), 1000

  getUnActiveed: ->
    models = @collection.where actived: false
    models[0]
