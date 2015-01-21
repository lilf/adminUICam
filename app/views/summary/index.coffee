Indicators = require 'models/indicators'
IMRS = require 'models/IMRS'
Categories = require 'models/categories'
Category_indicator = require 'models/category_indicators'
Logs = require 'models/logs'
SummaryView = require './summary_view'

module.exports = class SummaryNode extends Backbone.Node

  initialize: ->
    @imrs = new IMRS
    @indicators = new Indicators
    @categories = new Categories
    @category_indicator = new Category_indicator
    @logs = new Logs
    @tableData = {}

    @listenTo @indicators, 'series:done', @fetchIMRSFinished
    @listenTo @indicators,'fetch:IMRS', @fetchIMRS

    @TableData = new Backbone.Collection
    @summary_view = new SummaryView collection: @TableData
    $('#main_view').html @summary_view.render().el

  ready: ->
    @fetchIndicators()

  fetchIndicators: ->
    $
    .when @indicators.fetch(), @category_indicator.fetch(), @categories.fetch()
    .then =>
      @series @indicators, 'fetch:IMRS'


  series: (collection, event, getNext, delay = 10) ->
    i = 0
    getNext ?= (i) -> collection.at i
    first = getNext i
    return unless first

    fn = ()->
      i++
      return collection.trigger 'series:done' if i is collection.length
      model = getNext i
      setTimeout (-> model.trigger event, model, fn), delay

    first.trigger event, first, fn

  fetchIMRS: (indicator, callback) ->
    $
    .when @_fetchIMRS indicator
    .then =>
      indicator_id = indicator.id
      category_id = @category_indicator.getCategoryIds indicator_id
      categories = @categories.toJSON()
      category = _.where categories, _id: category_id

      if category.length > 0
        categoryName = category[0].name
      else
        categoryName = ''

      imrs = @imrs.toJSON()
      if imrs.indicators.length > 0
        @parseIMRS imrs, categoryName

      callback()

  _fetchIMRS: (indicator)->
    # console.log indicator.get('name')
    indicator_id = indicator.id
    # console.log indicator_id
    @imrs.fetch data: { indicator_id }


  fetchIMRSFinished: ->
    @summary_view.getTableOption()

    this


  parseIMRS: (imrs, categoryName)->
    indicators = imrs.indicators
    modes = imrs.modes
    rawdatas = imrs.rawdatas
    rawdatasNew = _.compact rawdatas

    sources = imrs.sources
    IMRSValue = imrs.imrs
    # console.log IMRSValue
    indicatorName = @getIndicatorName indicators
    # console.log indicatorName

    for i in [0...modes.length]
      mode = modes[i]
      modeId = mode._id
      sourceId = @getSourceId modeId, IMRSValue


      modeName = @getModeName mode
      period = @getPeriod modeName
      column = @getColumns modeName

      [sourceName, publisher] = @getSourceInfo sourceId, sources

      timeScope = @getTimeScope modeId, IMRSValue, rawdatasNew, period

      latestUpdateTime = @getLatestUpdateTime modeId, IMRSValue

      rawdatasId = @getRawdatasId modeId, IMRSValue, latestUpdateTime

      latestUpdateTimeNew = moment(latestUpdateTime).format("YYYY-MM-DD,h:mm:ss a")
      # console.log latestUpdateTimeNew

      # latestUpdateTimeNew = ers.timeToLocaleString (new Date latestUpdateTime)

      tableData =
        Category: categoryName,
        Indicator: indicatorName,
        Mode: modeName,
        DateColumn: period,
        Column: column,
        SourceName: sourceName,
        Publisher: publisher,
        latestUpdateTime: latestUpdateTimeNew,
        timeScope: timeScope

      @getLatestUpdateUser rawdatasId, tableData, (_tableDataWithUser) =>
        # console.log @tableData
        dataModel = new Backbone.Model _tableDataWithUser
        @TableData.add dataModel

  getIndicatorName: (indicators) ->
    indicator = indicators[0]
    indicatorName = indicator.name

    indicatorName

  getModeName: (mode) ->
    modeName = mode.name

    modeName

  getPeriod: (modeName) ->
    year = /year/
    month = /month/
    quarter = /quarter/
    if (year.test modeName) and !(month.test modeName) and !(quarter.test modeName)
      period = 'year'
    if (year.test modeName) and (month.test modeName)
      period = 'month'
    if (year.test modeName) and (quarter.test modeName)
      period = 'quarter'

    period

  getColumns: (modeName) ->
    start = _.indexOf modeName, '('
    end = _.indexOf modeName, ')'
    modeNameNew = modeName.substring start + 1, end
    # console.log modeNameNew

    # re = [/[-\+]year/, /[-\+]quarter/, /[-\+]month/, /[-\+]value/,/year/, /quarter/, /month/, /value/]
    re = [/[-\+]*year/, /[-\+]*quarter/, /[-\+]*month/, /[-\+]*value/]
    for m in re
      modeNameNew = modeNameNew.replace m , '' if m.test modeNameNew
    # console.log modeNameNew

    modeNameNew

  getSourceId: (modeId, IMRSValue) ->
    imrsvalue = _.findWhere IMRSValue, mode_id: modeId
    source_id = imrsvalue.source_id

    source_id

  getSourceInfo: (sourceId, sources) ->
    source = _.findWhere sources, _id: sourceId
    [sourceName, publisher] = [source.name, source.publisher]

    [sourceName, publisher]

  getTimeScope: (modeId, IMRSValue, rawdatas, period) ->
    rawdata = []
    rawdatas_IMRSValue = _.where IMRSValue, mode_id: modeId
    rawdatasIds = _.pluck rawdatas_IMRSValue, 'rawdata_id'
    for i in [0...rawdatasIds.length]
      rawdata.push  _.findWhere rawdatas, _id: rawdatasIds[i]

    rawdata = _.compact rawdata

    switch period
      when 'year' then  timeScope = @yearFormate rawdata
      when 'month' then timeScope = @monthFormate rawdata
      when 'quarter' then timeScope = @quarterFormate rawdata
      else ''

    timeScope

  yearFormate: (rawdata) ->
    rawdatas_year = _.pluck rawdata, 'year'
    rawdatas_year = _.compact rawdatas_year
    # console.log rawdatas_year
    # if _.isString rawdatas_year[0]
    #   rawdatasNew = []
    #   for i in [0...rawdatas_year.length]
    #     m = moment()
    #     m.set 'year', (rawdatas_year[i]).substr 0, 4
    #     rawdatasNew.push m.year()

    #   maxYearLeft = _.max rawdatasNew
    #   maxYearRight = maxYearLeft + 1
    #   maxYearScope = maxYearLeft + '/' + maxYearRight
    #   minYearLeft = _.min rawdatasNew
    #   minYearRight = minYearLeft + 1
    #   minYearScope = minYearLeft + '/' + minYearRight
    #   yearScope = minYearScope + '-' + maxYearScope

    # else
    rawdatas_year = rawdatas_year.sort()
    maxYear = _.last rawdatas_year
    minYear = _.first rawdatas_year
    yearScope = minYear  + '-' + maxYear

    yearScope

  monthFormate: (rawdata) ->
    rawdatas_month = []
    for i in [0...rawdata.length]
      rawdatas_month.push {
          year: rawdata[i].year
          month: rawdata[i].month
        }
    yearMonthScope = @formateYearMonth rawdatas_month

    yearMonthScope

  quarterFormate: (rawdata) ->
    rawdatas_quarter = []
    for i in [0...rawdata.length]
      rawdatas_quarter.push {
          year: rawdata[i].year
          quarter: rawdata[i].quarter
        }
    yearQuarterScope = @formateYearQuarter rawdatas_quarter

    yearQuarterScope

  formateYearMonth: (rawdatas_month) ->
    date = []
    for i in [0...rawdatas_month.length]
      m = moment()
      m.set 'year', rawdatas_month[i].year
      m.set 'month', rawdatas_month[i].month
      date.push  m.subtract(1, 'months').startOf('month')

    maxYearMonth = _.max date
    minYearMonth = _.min date
    maxYear = (moment maxYearMonth).year()
    maxMonth = (moment maxYearMonth).month()
    maxMonth = maxMonth + 1
    maxYearMonthValue = maxYear + '/' + maxMonth
    minYear = (moment minYearMonth).year()
    minMonth = (moment minYearMonth).month()
    minMonth = minMonth + 1
    minYearMonthValue = minYear + '/' + minMonth
    yearMonthScope = minYearMonthValue + '-' + maxYearMonthValue

    return yearMonthScope

  # getMonth: (month) ->
  #   switch month
  #    when 0 then monthNew = 1
  #    when 11 then monthNew = 12
  #    else monthNew = month

  #   monthNew

  formateYearQuarter: (rawdatas_quarter) ->
    date = []
    for i in [0...rawdatas_quarter.length]
      m = moment()
      m.set 'year', rawdatas_quarter[i].year
      m.set 'quarter', rawdatas_quarter[i].quarter
      date.push m.startOf('quarter')

    maxYearQuarter = _.max date
    minYearQuarter = _.min date
    maxYear = (moment maxYearQuarter).year()
    maxQuarter = (moment maxYearQuarter).quarter()
    maxYearQuarter = maxYear + 'Q' + maxQuarter
    minYear = (moment minYearQuarter).year()
    minQuarter = (moment minYearQuarter).quarter()
    minYearQuarter = minYear + 'Q' + minQuarter
    yearQuarterScope = minYearQuarter + '-' + maxYearQuarter

    return yearQuarterScope

  getLatestUpdateTime: (modeId, IMRSValue) ->
    latestUpdatedIMRS = _.where IMRSValue, mode_id: modeId
    times = _.pluck latestUpdatedIMRS, 'created_at'
    times = _.map times, (time) -> moment time
    latestUpdateTime = _.max times
    latestUpdateTime = latestUpdateTime._i

    latestUpdateTime

  getRawdatasId: (modeId, IMRSValue, latestUpdateTime) ->
    latestUpdatedIMRS = _.where IMRSValue, mode_id: modeId, created_at: latestUpdateTime
    rawdatasId = latestUpdatedIMRS[0].rawdata_id

    rawdatasId

  getLatestUpdateUser: (rawdatasId, tableData, callback) ->
    $
    .when @_fetchlog rawdatasId
    .then (logs) =>
      tableData.latestUpdateUser = logs[0].username
      callback tableData

  _fetchlog: (rawdatasId) ->
    @logs.fetch
      data:
        table: 'rawdata'
        id: rawdatasId






