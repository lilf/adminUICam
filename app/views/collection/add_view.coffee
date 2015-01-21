module.exports = class AddView extends Backbone.View

  events:
    'click button.create-button': 'create'
    'click button.cancel-create-button': 'cancelCreate'

  initialize: (options) ->
    @template = options.template
    @listenTo @model, 'change remove model:show', @remove
    @listenTo @model, 'change', @show

  render: ->
    @$el.html @template()

    this

  create: ->
    json = @$el.toObject()
    @model.save json, wait: true, success: => @model.trigger 'model:created', @model

  cancelCreate: ->
    @model.collection.remove @model

  show: ->
    @model.trigger 'model:show', @model
