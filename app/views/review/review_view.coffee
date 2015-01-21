module.exports = class ReviewView extends Backbone.View

  template: require './templates/review'

  render: ->
    @$el.html @template()

    this
