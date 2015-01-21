config = require 'config'

class Template extends Backbone.Model

  idAttribute: '_id'

  defaults:
    name: 'name not found'
    profile:
      variables: []
      components: []

module.exports = class Templates extends Backbone.Collection

  model: Template

  url: ->
    config.api.baseUrl + '/templates'

  comparator: 'order'

  parse: (data) ->
    _.sortBy data, @comparator
