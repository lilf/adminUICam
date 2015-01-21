module.exports = class LogView extends Backbone.View

  template: require './templates/log'

  render: ->
    @$el.html @template()

    this
