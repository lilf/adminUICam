MetaView = require './meta_view'
ListView = require './list_view'
Names = require 'models/names'

module.exports = class MetaNode extends Backbone.Node

  initialize: ->
    @collection = new Names
    @meta_view = new MetaView
    @list_view = new ListView {@collection}

    @listenTo @collection, 'series:done', @whenReordered

    @listenTo @meta_view, 'change:table', @changeTable
    @listenTo @meta_view, 'save:order', @saveOrder
    $('#main_view').html @meta_view.render().el
    $('#meta-list-view').html @list_view.render().el

  whenReordered: ->
    $.UIkit.notify "<i class='uk-icon-check'></i> order saved", status: 'success'

  changeTable: (table) ->
    collection = @getCollection table
    @listenToOnce collection, 'reset', @dataFetched
    @collection.url = collection.url()
    collection.fetch reset: true

  dataFetched: (collection) ->
    @collection.remove @collection.models
    @collection.add collection.toJSON()
    @list_view.removeEmptyItem()

  getCollection: (table) ->
    switch table
      when 'columns' then new (require 'models/columns')
      when 'modes' then new (require 'models/modes')
      when 'categories' then new (require 'models/categories')
      when 'indicators' then new (require 'models/indicators')
      when 'sources' then new (require 'models/sources')
      when 'templates' then new (require 'models/templates')

  saveOrder: ->
    @series @collection, 'save:order'
