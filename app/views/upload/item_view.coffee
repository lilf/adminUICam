module.exports = class ItemView extends Backbone.View

  template: require './templates/item'

  tagName: 'tr'

  initialize: ->
    @listenTo @model, 'remove', @remove
    @listenTo @model, 'request', @todo 'save', 'waiting'
    @listenTo @model, 'change', @todo 'save', 'end'
    @listenTo @model, 'error', @todo 'save', 'error'

    @listenTo @model, 'reach:request', @todo 'reach', 'waiting'
    @listenTo @model, 'reach:change', @todo 'reach', 'end'
    @listenTo @model, 'reach:error', @todo 'reach', 'error'

  render: ->
    @$el.html @template data: @model.toJSON()
    @start()
    this

  todo: (args...) ->
    => @toggle args...

  start: ->
    @toggle 'save', 'start'
    @toggle 'reach', 'start'
    @toggle 'log', 'start'

  toggle: (type, status) ->
    switch type
      when 'save' then @toggleStatus '.uk-badge-success', status
      when 'reach' then @toggleStatus '.uk-badge-info', status

  toggleStatus: (selector, status) ->
    switch status
      when 'start' then @toggleIcon selector, '.uk-icon-asterisk'
      when 'waiting' then @toggleIcon selector, '.uk-icon-spinner'
      when 'end' then @toggleIcon selector, '.uk-icon-check'
      when 'error' then @toggleIcon selector, '.uk-icon-warning'

  toggleIcon: (selector, icon) ->
    @$(selector + ' ' + icon)
    .show()
    .siblings()
    .hide()




