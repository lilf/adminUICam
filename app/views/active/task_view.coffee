module.exports = class TaskView extends Backbone.View

  template: require './templates/task'

  tagName: 'tr'

  events:
    'click button.active-button': 'active'

  initialize: ->
    @listenTo @model, 'model:fetch', @fetch
    @listenTo @model, 'model:active', @active
    Collection = @model.get 'collection'
    @collection = new Collection
    @listenToOnce @collection, 'request', @start
    @listenTo @collection, 'reset', @end
    @listenTo @collection, 'error', @error

  render: ->
    @$el.html @template @model.toJSON()
    @$count = @$('td[name=count]')
    @$progressbar = @$('div.uk-progress-bar')

    this

  fetch: ->
    @collection.fetch data: {active: false}, reset: true

  start: ->
    @$count.html 'fetching...'

  end: ->
    setTimeout (=> @$count.html @collection.length), 1000
    @model.set fetched: true

  error: ->
    @$count.html 'error with server'

  setProgress: ->
    models = @collection.where active: true
    progress = Math.round models.length / @collection.length * 100
    @_setProgress progress + '%'

  _setProgress: (percent) ->
    @$progressbar.css 'width', percent
    @$progressbar.text percent

  active: ->
    self = this
    model = @getDisabled()
    @setProgress()
    return @model.set actived: true unless model

    @listenToOnce model, 'sync', @active, this
    success = ->
      m = self.model
      table = m.get('table').toLowerCase()
      m.trigger 'model:actived', 'active', table, model.id, model.toJSON()
    setTimeout (-> model.save {active: true}, {wait: true, success: success}), 100

  getDisabled: ->
    models = @collection.where active: false
    models[0]

