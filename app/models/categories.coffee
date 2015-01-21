config = require 'config'

class Category extends Backbone.Model

  idAttribute: '_id'

module.exports = class Categories extends Backbone.Collection

  model: Category

  url: ->
    config.api.baseUrl + '/categories'

  comparator: 'order'

  parse: (data) ->
    _.sortBy data, @comparator



