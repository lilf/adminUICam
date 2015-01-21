HeaderView = require './header_view'
Links = require 'models/links'
links = require './links'
module.exports = class HeaderNode extends Backbone.Node

  requires:
    'router': 'router'

  initialize: ->
    @collection = new Links
    @header_view = new HeaderView {@collection}
    $('#header_view').html @header_view.render().el
    @collection.set links
    @on 'router:required', @test

  ready: ->
    @listenTo @router, 'route', @activeLink

  activeLink: (selector) ->
    link = @collection.findWhere {selector}
    link and link.trigger 'model:active'
