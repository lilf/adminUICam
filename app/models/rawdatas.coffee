config = require 'config'

class Rawdata extends Backbone.Model

  idAttribute: '_id'

module.exports = class Rawdatas extends Backbone.Collection

  model: Rawdata

  url: ->
    config.api.baseUrl + '/rawdatas'

  getNew: ->
    models = @filter (model) -> model.isNew()
    models[0]

  getOld: ->
    models = @reject (model) -> model.isNew()
    models[0]
