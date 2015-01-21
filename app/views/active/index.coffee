ActiveView = require './active_view'
tasks = require './tasks'

module.exports = class ActiveNode extends Backbone.Node

  initialize: ->
    @collection = new Backbone.Collection
    @listenTo @collection, 'model:actived', @domainProxy('log')

    @active_view = new ActiveView {@collection}
    $('#main_view').html @active_view.render().el
    @collection.add  tasks
    @active_view.fetch()
