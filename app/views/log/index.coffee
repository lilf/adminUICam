Logs = require 'models/logs'
LogView = require './log_view'
options = require './data'
options2 = require './options'
loading = require './loading'

module.exports = class LogNode extends Backbone.Node

  initialize: ->
    @collection = new Logs
    @listenTo @collection, 'sync', @render
    @log_view = new LogView
    $('#main_view').html @log_view.render().el
    @initChart()

    @collection.fetch()

  render: ->
    @drawUser @collection.groupBy (model) -> model.get 'username'
    @drawType @collection.groupBy (model) -> model.get 'type'
    @drawTable @collection.groupBy (model) -> model.get 'table'

  initChart: ->
    @userChart = echarts.init @log_view.$('#by-user')[0]
    @typeChart = echarts.init @log_view.$('#by-type')[0]
    @tableChart = echarts.init @log_view.$('#by-table')[0]
    @userChart.showLoading loading(1)
    @typeChart.showLoading loading(2)
    @tableChart.showLoading loading(3)

  drawUser: (models) ->
    option = options2 'user', models
    @userChart.setOption option
    @userChart.hideLoading()

  drawType: (models) ->
    option = options2 'type', models
    @typeChart.setOption option
    @typeChart.hideLoading()

  drawTable: (models) ->
    option = options2 'table', models
    @tableChart.setOption option
    @tableChart.hideLoading()
