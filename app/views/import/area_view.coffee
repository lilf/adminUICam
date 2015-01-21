module.exports = class AreaView extends Backbone.View

  template: require './templates/area'

  tagName: 'li'

  render: ->
    @$el.html @template @model.toJSON()
    @$el.addClass 'uk-active' if @model.get 'active'

    this
