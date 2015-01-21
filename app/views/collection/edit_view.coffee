module.exports = class EditView extends Backbone.View

  events:
    'click button.save-button': 'save'
    'click button.cancel-edit-button': 'cancelEdit'

  initialize: (options) ->
    @template = options.template
    @listenTo @model, 'change', @cancelEdit

  render: ->
    @$el.html @template @model.toJSON()

    this

  save: ->
    json = @$el.toObject()
    type = if @model.isNew() then 'model:created' else 'model:updated'
    @model.save json, wait: true, success: => @model.trigger type, @model

  cancelEdit: ->
    @remove()
    if @model.isNew()
      @model.collection.remove @model
    else
      @model.trigger 'model:show', @model
