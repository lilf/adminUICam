ImportView  = require './import_view'
Links = require 'models/links'
links = require './links'

module.exports = class ImportNode extends Backbone.Node

  requires:
    router: 'router'

  initialize: ->
    @collection = new Links
    @listenTo @collection, 'active:link', @activeLink

    @import_view = new ImportView {@collection}
    $('#main_view').html @import_view.render().el
    @collection.set links

  ready: (params) ->
    [selector] = params
    if selector and model = @collection.findWhere {selector}
      # console.log model
      model.trigger 'show:link'

  activeLink: (model) ->
    # console.log model.get('selector')
    @router.navigate '#import/' + model.get('selector')

