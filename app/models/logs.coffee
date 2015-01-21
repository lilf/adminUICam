config = require 'config'

class Log extends Backbone.Model

  idAttribute: '_id'

module.exports = class Logs extends Backbone.Collection

  model: Log

  url: ->
    config.api.baseUrl + '/logs'

  getInfo: ->
    url = @url() + '/info'
    $.get url, (data) => @trigger 'log:info', data

  search: (query = {}) ->
    url = @url() + '/search'
    $.post url, query, (data) =>
      @remove @models
      @add data
      @trigger 'searched', data
