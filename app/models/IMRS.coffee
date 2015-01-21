config = require 'config'

module.exports = class IMRS extends Backbone.Model

  url: ->
    config.api.baseUrl + '/imrs'
