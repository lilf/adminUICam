Rawdatas = require 'models/rawdatas'
IndicatorModeRawdataSources = require 'models/indicator_mode_rawdata_sources'
UploadView = require './upload_view'
ListView = require './list_view'

module.exports = class UploadNode extends Backbone.Node

  defines:
    imrs: 'collection'

  requires:
    sources: 'sources'
    indicators: 'indicators'
    modes: 'modes'
    columns: 'columns'
    column_modes: 'column_modes'

  initialize: ->
    @collection = new IndicatorModeRawdataSources
    @rawdatas = new Rawdatas
    @upload_view = new UploadView
    @list_view = new ListView collection: @rawdatas

    @listenTo @rawdatas, 'sync', @whenRawdataSynced
    @listenTo @rawdatas, 'destroy', @whenRawdataDestroyed
    @listenTo @upload_view, 'rawdatas:converted', @renderRawdatas
    @listenTo @upload_view, 'mode:changed', @changeMode

    @listenTo @list_view, 'column:order:changed', @columnsOrderChanged

    $('#upload').html @upload_view.render().el
    @upload_view.$('.preview-rawdata').html @list_view.render().el

  ready: ->
    @listenTo @sources, 'sync', @renderSourceOption
    @listenTo @indicators, 'sync', @renderIndicatorOption
    @listenTo @modes, 'sync', @renderModeOption
    @listenToOnce @column_modes, 'sync', @enableModesOptions

  whenRawdataSynced: (model) ->
    imrs = _.pick @formData, 'source_id', 'indicator_id', 'mode_id'
    imrs.rawdata_id = model.id

    @collection.create imrs,
      beforeSend: -> model.trigger 'reach:request'
      success: -> model.trigger 'reach:change'
      error: -> model.trigger 'reach:error'
    @domainPub 'log', 'create', 'rawdata', model.id, model.toJSON()

  whenRawdataDestroyed: (model) ->
    imrs = @collection.findWhere rawdata_id: model.id
    imrs.destroy success: => @rawdatas.add model.pick @fields...
    @domainPub 'log', 'destroy', 'rawdata', model.id, model.toJSON()

  enableModesOptions: ->
    @upload_view
    .$ 'select[name=mode_id]'
    .removeAttr 'disabled'

  renderSourceOption: ->
    @renderCollectionOptions @sources, 'source_id'

  renderIndicatorOption: ->
    @renderCollectionOptions @indicators, 'indicator_id'

  renderModeOption: ->
    @renderCollectionOptions @modes, 'mode_id'

  renderCollectionOptions: (collection, name) ->
    $select = @upload_view
    .$ 'select[name=' + name + ']'
    .html @renderOptions collection

    # need to destroy the old one if already selectized
    selectize = $select[0].selectize
    selectize.destroy() if selectize

    $select.selectize()

  renderOptions: (collection) ->
    array = collection.toJSON()
    array.unshift _id: '', name: 'None'
    array.map (json) -> $ '<option>', value: json._id, text: json.name

  renderRawdatas: (json, matrix) ->
    fields = @fields
    @formData = json
    @matrix = matrix
    @_renderRawdatas fields, matrix

  _renderRawdatas: (fields, matrix) ->
    @list_view.$('thead tr:last').show()
    @list_view.reset()
    data = _.map matrix, (row) -> _.object fields, row
    @rawdatas.add data

  columnsOrderChanged: (indexes) ->
    matrix = ers.permuteMatrix @matrix, indexes
    @_renderRawdatas @fields, matrix

  changeMode: (mode_id) ->
    column_modes = @column_modes.where {mode_id}
    columns = _.chain column_modes
      .sortBy (column_mode) -> column_mode.get 'created_at'
      .map (column_mode) => @columns.get column_mode.get 'column_id'
      .map (column) -> column.get 'name'
      .value()

    @fields = columns
    @list_view.renderThead columns
