config = require 'config'

class Indicator extends Backbone.Model

  idAttribute: '_id'

module.exports = class Indicators extends Backbone.Collection

  model: Indicator

  url: ->
    config.api.baseUrl + '/indicators'

  comparator: 'order'

  parse: (data) ->
    _.sortBy data, @comparator
