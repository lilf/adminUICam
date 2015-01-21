Router = require 'router'

module.exports = class Application extends Backbone.Node

  defines: ->
    router: 'router'

  initialize: ->
    @router = new Router
    @listenTo @router, 'route', @domainProxy 'route'
