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
    @listenTo @collectionA, 'sync', @renderCollectionAOptions
    @listenTo @collectionB, 'sync', @renderCollectionBOptions
    @collection.fetch()

  updateModel: (model) ->
    model.set 'column_name', @collectionA.get(model.get 'column_id').get 'name'
    model.set 'mode_name', @collectionB.get(model.get 'mode_id').get 'name'

  renderCollectionBOptions: ->
    @relation_view
    .$ 'select[name=mode_id]'
    .html @renderOptions @collectionB

  renderCollectionAOptions: ->
    @relation_view
    .$ 'select[name=column_id]'
    .html @renderOptions @collectionA

  renderOptions: (collection) ->
    array = collection.toJSON()
    array.unshift _id: '', name: 'None'
    array.map (json) -> $ '<option>', value: json._id, text: json.name
