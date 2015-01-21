config = require 'config'

class Mode extends Backbone.Model

  idAttribute: '_id'

module.exports = class Modes extends Backbone.Collection

  model: Mode

  url: ->
    config.api.baseUrl + '/modes'

  comparator: 'order'

  parse: (data) ->
    _.sortBy data, @comparator
