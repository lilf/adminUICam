module.exports = class ItemView extends Backbone.View

  template: require './templates/item'

  events:
    'click button.edit-button': 'edit'
    'click button.destroy-button': 'destroy'
    'click button.save-button': 'save'
    'click button.cancel-button': 'cancel'

  initialize: ->
    @listenTo @model, 'remove', @remove
    @listenTo @model, 'sync', @cancel
    @listenTo @model, 'change', @change

  render: ->
    @$el.html @template data: @model.omit '_id', '__v', 'active'

    @$("[data-uk-margin]").ukMargin()
    @$for_edit = @$ '.for-edit'
    @$for_show = @$ '.for-show'
    @cancel()

    this

  change: ->
    changed = @model.changedAttributes()
    @$('span[name=' + name + '-value]').text value for name, value of changed

  edit: ->
    @$for_edit.show()
    @$for_show.hide()

  destroy: ->
    return unless confirm 'sure to delete?'
    @model.destroy wait: true

  save: ->
    json = @$el.toObject()
    @model.save json, wait: true

  cancel: ->
    @$for_edit.hide()
    @$for_show.show()
    @$('input[name=' + name + ']').val value for name, value of @model.toJSON()
