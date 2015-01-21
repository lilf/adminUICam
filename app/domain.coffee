Logs = require 'models/logs'

module.exports = class Domain extends Backbone.Domain

  initialize: ->
    @logs = new Logs
    @on 'route', @switchNode
    @on 'echarts', @draw
    @on 'log', @logWithUser

  draw: (name, dom) ->
    demo.drawByName name, dom

  log: (username, type, table, id, data, options = {}) ->
    @logs.create {username, type, table, id, data}, options

  logWithUser: (type, table, id, data, options) ->
    @log @me.get('username'), type, table, id, data, options

  login: (@me) ->
    @listenToOnce @me, 'me:logout', @logout
    @logWithUser 'login', 'user', @me.id, @me.toJSON()

  logout: (callback) ->
    @logWithUser 'logout', 'user', @me.id, @me.toJSON(), success: callback
