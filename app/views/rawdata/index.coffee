Rawdatas = require 'models/rawdatas'
IndicatorModeRawdataSources = require 'models/indicator_mode_rawdata_sources'

RawdataView = require './rawdata_view'
IMRSView = require './imrs_view'
ColumnView = require './column_view'
ListView = require './list_view'

module.exports = class RawdataNode extends Backbone.Node

  requires:
    sources: 'sources'
    modes: 'modes'
    indicators: 'indicators'
    columns: 'columns'

  initialize: ->
    @collection = new Rawdatas
    @imrs = new IndicatorModeRawdataSources
    @imrs2 = new IndicatorModeRawdataSources
    @rawdata_view = new RawdataView
    @imrs_view = new IMRSView collection: @imrs
    @list_view = new ListView {@collection}

    @listenTo @collection, 'error', @alertError
    @listenTo @collection, 'change', @logChange
    @listenTo @collection, 'destroy', @destroy
    @listenTo @imrs2, 'sync', @clearImrs
    @listenTo @imrs, 'sync', @fetchFromImrs

    $('#rawdata').html @rawdata_view.render().el
    $('#search-by-imrs').html @imrs_view.render().el
    $('#rawdata-list').html @list_view.render().el

  ready: ->
    @column_view = new ColumnView collection: @columns
    @listenTo @column_view, 'view:search', @fetch
    $('#search-by-column').html @column_view.render().el

    @listenTo @sources, 'sync', @renderSourceOption
    @listenTo @indicators, 'sync', @renderIndicatorOption
    @listenTo @modes, 'sync', @renderModeOption

  alertError: (mc, resp, options) ->
    alert resp.responseText

  logChange: (model) ->
    @domainPub 'log', 'update', 'rawdata', model.id, model.toJSON()

  destroy: (model) ->
    @imrs2.fetch data: rawdata_id: model.id
    @domainPub 'log', 'destroy', 'rawdata', model.id, model.toJSON()

  clearImrs: ->
    @imrs2.each (imrs) -> imrs.destroy wait: true

  fetch: (json) ->
    @collection.remove @collection.models
    @collection.fetch data: json

  fetchFromImrs: ->
    url = @collection.url()
    @imrs.each (imrs) => $.get url, {_id: imrs.get('rawdata_id')}, (data) => @collection.add data

  renderSourceOption: ->
    @renderCollectionOptions @sources, 'source_id'

  renderIndicatorOption: ->
    @renderCollectionOptions @indicators, 'indicator_id'

  renderModeOption: ->
    @renderCollectionOptions @modes, 'mode_id'

  renderCollectionOptions: (collection, name) ->
    $select = @imrs_view
    .$ 'select[name=' + name + ']'
    .html @renderOptions collection

    # need to destroy the old one if already selectized
    selectize = $select[0].selectize
    selectize.destroy() if selectize

    $select.selectize()

  renderOptions: (collection) ->
    array = collection.toJSON()
    array.map (json) -> $ '<option>', value: json._id, text: json.name
