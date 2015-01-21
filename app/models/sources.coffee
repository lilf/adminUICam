config = require 'config'

class Source extends Backbone.Model

  idAttribute: '_id'

module.exports = class Sources extends Backbone.Collection

  model: Source

  url: ->
    config.api.baseUrl + '/sources'

  comparator: 'order'

  parse: (data) ->
    _.sortBy data, @comparator
