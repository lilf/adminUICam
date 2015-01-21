module.exports = class ShowView extends Backbone.View

  events:
    'click button.edit-button': 'edit'
    'click button.copy-button': 'copy'
    'click button.destroy-button': 'destroy'

  initialize: (options) ->
    @template = options.template
    @listenTo @model, 'model:edit model:copy remove', @remove

  render: ->
    @$el.html @template @model.toJSON()

    this

  edit: ->
    @model.trigger 'model:edit', @model

  copy: ->
    @model.trigger 'model:copy', @copy_()

  destroy: ->
    return unless confirm 'sure to delete the project?'
    @model.destroy wait: true

  copy_: ->
    json = $.extend true, {}, @model.toJSON()
    json.name += _.uniqueId 'copy_'
    delete json._id
    json
