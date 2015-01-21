Collection = require 'models/categories'
ListView = require 'views/collection/list_view'
BatchView = require 'views/batch/batch_view'

templates =
  list: require './templates/list'
  add: require './templates/add'
  edit: require './templates/edit'
  item: require './templates/item'
  show: require './templates/show'

module.exports = class ColumnNode extends Backbone.Node

  defines:
    categories: 'collection'

  initialize: ->
    @collection = new Collection
    @list_view = new ListView {@collection, templates}
    @batch_view = new BatchView fields: ['name']

    @listenTo @collection, 'model:created', @logCreate
    @listenTo @collection, 'model:updated', @logUpadte
    @listenTo @collection, 'destroy', @logDestroy

    @listenTo @list_view, 'view:show', @showView
    @listenTo @list_view, 'view:add', @addView
    @listenTo @list_view, 'view:edit', @editView

    @listenTo @batch_view, 'view:data:ready', @list_view.createByName, @list_view

    $('#category').html @list_view.render().el
    @list_view.$('p').append @batch_view.render().el

  ready: ->
    @collection.fetch()

  showView: (view) ->

  addView: (view) ->
    view
    .$ 'input:first'
    .focus()

  editView: (view) ->
    view
    .$ 'input:first'
    .focus()

  logCreate: (model) ->
    @domainPub 'log', 'create', 'category', model.id, model.toJSON()

  logUpadte: (model) ->
    @domainPub 'log', 'update', 'category', model.id, model.toJSON()

  logDestroy: (model) ->
    @domainPub 'log', 'destroy', 'category', model.id, model.toJSON()
