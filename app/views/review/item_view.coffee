module.exports = class ItemView extends Backbone.View

  template: require './templates/item'

  tagName: 'tr'

  events:
    'click': 'toggle'

  initialize: ->
    @listenTo @model, 'remove', @remove

  render: ->
    json = @model.toJSON()
    json.data = _.omit json.data, '__v'
    json.data = JSON.stringify json.data, null, '\t'
    json.created_at = ers.timeToLocaleString json.created_at
    json.browser = if json.ua then json.ua.browser.name + json.ua.browser.major else '-'

    @$el.html @template json
    @$('pre').hide()

    this

  toggle: ->
    @$('pre').toggle()
    @$('.elipse').toggle()
