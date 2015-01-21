config = require 'config'
csv = require './csv'

module.exports = class RawdataView extends Backbone.View

  template: require './templates/rawdata'

  events:
    'change select[name=mode_id]': 'changeThead'
    'click button.preview-button': 'preview'

  render: ->
    @$el.html @template()
    @$('select[name=encoding]').val @detectEncoding()
    @$("[data-uk-margin]").ukMargin()

    this

  changeThead: (e) ->
    @trigger 'mode:changed', e.target.value

  preview: ->
    if @$('input[type=file]').is(':visible') then @readFile()
    if @$('textarea[name=from_text]').is(':visible') then @readText()

  detectEncoding: ->
    switch navigator.language
      when 'zh-CN' then 'GBK'
      when 'zh-TW' then 'BIG5'
      else 'UTF-8'

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
    json = @getFormData()
    return unless json
    $.ajax
      url: config.api.baseUrl + '/csv/convert'
      access_token: true
      type: 'POST'
      data: param
      success: (text) =>
        data = csv.parse text, header: false
        @trigger 'rawdatas:converted', json, data.results
      error: (jqXHR) => alert jqXHR.responseText

  getFormData: ->
    json = @$el.toObject()
    msg = 'please select source first' unless json.source_id
    msg = 'please select indicator first' unless json.indicator_id
    msg = 'please select mode first' unless json.mode_id
    if msg
      alert msg
      false
    else
      json
