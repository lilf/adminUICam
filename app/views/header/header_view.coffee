LinkView = require './link_view'

module.exports = class HeaderView extends Backbone.View

  template: require './templates/header'

  initialize: ->
    @listenTo @collection, 'add', @addLink

  render: ->
    @$el.html @template()
    @$list = @$('ul.uk-navbar-nav')

    this

  addLink: (model) ->
    link_view = new LinkView {model}
    @$list.append link_view.render().el
