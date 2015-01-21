Collection = require 'models/column_modes'
RelationView  = require 'views/relation/relation_view'
templates =
  relation: require './templates/relation'
  item: require './templates/item'

module.exports = class ColumnModeNode extends Backbone.Node

  defines:
    column_modes: 'collection'

  requires:
    columns: 'collectionA'
    modes: 'collectionB'

  initialize: ->
    @collection = new Collection
    @listenTo @collection, 'add', @updateModel
    @relation_view = new RelationView {@collection, templates}
    $('#column_mode').html @relation_view.render().el

  ready: ->
    @listenWhenOnce 'collectionA:sync collectionB:sync', @fetch
    @listenTo @collectionA, 'sync', @renderCollectionAOptions
    @listenTo @collectionB, 'sync', @renderCollectionBOptions

  fetch: ->
    @collection.fetch()

  updateModel: (model) ->
    column = @collectionA.get(model.get 'column_id')
    mode = @collectionB.get(model.get 'mode_id')
    column_name = if column then column.get 'name' else '---deleted---'
    mode_name = if mode then mode.get 'name' else '---deleted---'
    model.set 'column_name', column_name
    model.set 'mode_name', mode_name

    # order
    model.set 'order1', mode?.cid
    model.set 'order2', column?.cid

  renderCollectionBOptions: ->
    $select = @relation_view
    .$ 'select[name=mode_id]'
    .html @renderOptions @collectionB

    # need to destroy the old one if already selectized
    selectize = $select[0].selectize
    selectize.destroy() if selectize

    $select.selectize()

  renderCollectionAOptions: ->
    $select = @relation_view
    .$ 'select[name=column_id]'
    .html @renderOptions @collectionA

    # need to destroy the old one if already selectized
    selectize = $select[0].selectize
    selectize.destroy() if selectize

    $select.selectize()

  renderOptions: (collection) ->
    array = collection.toJSON()
    array.unshift _id: '', name: 'None'
    array.map (json) -> $ '<option>', value: json._id, text: json.name
