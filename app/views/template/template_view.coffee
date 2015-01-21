module.exports = class TemplateView extends Backbone.View

  template: require './templates/template'

  render: ->
    @$el.html @template()

    this
