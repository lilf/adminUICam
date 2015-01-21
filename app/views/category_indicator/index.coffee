Collection = require 'models/category_indicators'
RelationView  = require 'views/relation/relation_view'
templates =
  relation: require './templates/relation'
  item: require './templates/item'

module.exports = class CategoryIndicatorNode extends Backbone.Node

  defines:
    category_indicators: 'collection'

  requires:
    indicators: 'collectionA'
    categories: 'collectionB'

  initialize: ->
    @collection = new Collection
    @listenTo @collection, 'add', @updateModel
    @relation_view = new RelationView {@collection, templates}
    $('#category_indicator').html @relation_view.render().el

  ready: ->
    @listenWhenOnce 'collectionA:sync collectionB:sync', @fetch
    @listenTo @collectionA, 'sync', @renderCollectionAOptions
    @listenTo @collectionB, 'sync', @renderCollectionBOptions

  fetch: ->
    @collection.fetch()

  updateModel: (model) ->
    indicator = @collectionA.get(model.get 'indicator_id')
    category = @collectionB.get(model.get 'category_id')
    indicator_name = if indicator then indicator.get 'name' else '---deleted---'
    category_name = if category then category.get 'name' else '---deleted---'
    model.set 'indicator_name', indicator_name
    model.set 'category_name', category_name

    # order
    model.set 'order1', category?.cid
    model.set 'order2', indicator?.cid

  renderCollectionBOptions: ->
    $select =@relation_view
    .$ 'select[name=category_id]'
    .html @renderOptions @collectionB

    # need to destroy the old one if already selectized
    selectize = $select[0].selectize
    selectize.destroy() if selectize

    $select.selectize()

  renderCollectionAOptions: ->
    $select =@relation_view
    .$ 'select[name=indicator_id]'
    .html @renderOptions @collectionA

    # need to destroy the old one if already selectized
    selectize = $select[0].selectize
    selectize.destroy() if selectize

    $select.selectize()

  renderOptions: (collection) ->
    array = collection.toJSON()
    array.unshift _id: '', name: 'None'
    array.map (json) -> $ '<option>', value: json._id, text: json.name
