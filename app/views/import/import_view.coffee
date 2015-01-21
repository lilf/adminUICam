LinkView = require './link_view'
AreaView = require './area_view'

module.exports = class ImportView extends Backbone.View

  template: require './templates/import'

  initialize: ->
    @listenTo @collection, 'add', @addLink

  render: ->
    @$el.html @template()
    @$list = @$('ul.uk-subnav')
    @$area = @$('ul.uk-switcher')

    this

  addLink: (model) ->
    link_view = new LinkView {model}
    @$list.append link_view.render().el

    area_view = new AreaView {model}
    @$area.append area_view.render().el
