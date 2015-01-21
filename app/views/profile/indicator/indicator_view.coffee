config = require 'config'

module.exports = class IndicatorView extends Backbone.View

  template: require './templates/indicator'

  events:
    'change select[name=indicator_id]': 'select'
    'change select[name=profile_id]': 'load'
    'click button.save-profile': 'save'
    'click button.add-var': 'addVar'
    'click button.preview-profile-in-client': 'previewInClient'
    'click button.get-profile': 'getProfile'

  initialize: ->
    @listenTo @collection, 'reset', @reset

  render: ->
    @$el.html @template()

    this

  renderOptions: (placeholder = '') ->
    array = @collection.map (item)  -> item.toJSON()
    array.unshift _id: 'null', name: placeholder
    array.map (json) -> $ '<option>', value: json._id, text: json.name

  reset: ->
    @$('select[name=indicator_id]')
    .html @renderOptions 'please choose a indicator'
    .selectize()

    @$('select[name=profile_id]')
    .html @renderOptions 'load profile from another indicator'
    .selectize()

  select: (e) ->
    return if e.target.value is 'null'
    @collection.trigger 'set:profile:indicator_id', e.target.value

  getIndicatorId: ->
    indicator_id = @$('select[name=indicator_id]').val()
    if indicator_id is 'null' then null else indicator_id

  load: (e) ->
    value = if e.target.value is 'null' then null else e.target.value
    @collection.trigger 'load:profile:indicator_id', value

  save: ->
    @collection.trigger 'save:profile'

  addVar: ->
    value = @$('select[name=indicator_id]').val()
    return if value is 'null'
    @collection.trigger 'profile:add:variable', value

  previewInClient: ->
    value = @$('select[name=profile_id]').val()
    return if value is 'null'
    window.open config.client.indicator + value

  getProfile: ->
    value = @$('select[name=indicator_id]').val()
    return if value is 'null'
    @collection.trigger 'profile:get:profile', value
