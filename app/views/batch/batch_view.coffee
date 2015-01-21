csv = require './csv'

module.exports = class BatchView extends Backbone.View

  template: require './templates/batch'

  tagName: 'span'

  events:
    'click button.preview-button': 'preview'
    'click button.ok-button': 'ok'

  initialize: (options = {fields: ['fieldA']}) ->
    @collection = new Backbone.Collection
    @listenTo @collection, 'reset', @sendData
    @fields = options.fields

  render: ->
    @$el.html @template toggleClass: @cid, fields: @fields.join(' , ')
    @$('select[name=encoding]').val @detectEncoding()
    @$("[data-uk-margin]").ukMargin()
    @$status = @$ '.batch-status'
    @$current_row = @$ '.current-row'
    @$progressbar = @$ '.uk-progress-bar'
    @$status.hide()

    this

  detectEncoding: ->
    switch navigator.language
      when 'zh-CN' then 'GBK'
      when 'zh-TW' then 'BIG5'
      else 'UTF-8'

  ok: ->
    return alert 'fields not match' unless @matchFields @data.fields
    modal = $.UIkit.modal '#modal-' + @cid
    modal.hide()
    @collection.reset @data.rows
    @$status.show()

  updateProgress: ->
    b = @data.rows.length
    a = b - @collection.length
    @_updateProgress a + 1, b

  _updateProgress: (a, b) ->
    min = Math.min a, b
    max = Math.max a, b
    progress = Math.round min / max * 100
    @_setProgress progress + '%', min, max

  _setProgress: (percent, min, max) ->
    @$progressbar.css 'width', percent
    @$progressbar.text  min + ' / ' + max + ' ( ' + percent + ' )'

  clear: ->
    @$status.hide()
    @data = null

  sendData: ->
    collection = @collection
    model = collection.first()
    return @clear() unless model
    @updateProgress()
    @$current_row.text ' + : ' + model.get(@fields[0])
    @listenToOnce model, 'model:batch:done', @sendData, this
    @trigger 'view:data:ready', model.toJSON(), ->
      setTimeout (->
        model.trigger 'model:batch:done'
        collection.remove model
        ), 1000

  matchFields: (fields) ->
    fields.length is @fields.length and _.every @fields, (field) -> _.contains fields, field

  preview: ->
    if @$('input[type=file]').is(':visible') then @readFile()
    if @$('textarea[name=from_text]').is(':visible') then @readText()

  readFile: ->
    target = @$('input[type=file]')[0]
    return alert 'please select a csv file' unless target.files.length
    encoding = @$('select[name=encoding]').val()

    csv.parseFile target.files[0], encoding, @convert

  readText: ->
    text = @$('textarea[name=from_text]').val()
    return alert 'please enter a csv text' if text.length is 0
    @convert csv.parseText text

  convert: (param) =>
    data = csv.parse param.text
    @data = data.results
    ers.table.draw 'table-' + @cid, data.results.rows
    modal = $.UIkit.modal '#modal-' + @cid
    modal.show()
