module.exports = class IMRSView extends Backbone.View

  template: require './templates/imrs'

  events:
    'click button.search-button': 'search'

  render: ->
    @$el.html @template()
    @$("[data-uk-margin]").ukMargin()

    this

  search: ->
    json = @$el.toObject()
    @collection.fetch data: json

