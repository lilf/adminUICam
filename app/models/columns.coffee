config = require 'config'

class Column extends Backbone.Model

  idAttribute: '_id'

module.exports = class Columns extends Backbone.Collection

  model: Column

  url: ->
    config.api.baseUrl + '/columns'

  comparator: 'order'

  parse: (data) ->
    _.sortBy data, @comparator
