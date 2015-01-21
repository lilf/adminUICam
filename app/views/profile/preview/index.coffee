PreviewView = require './preview_view'
make_it_draggable = require './dragcomponent'

module.exports = class PreviewNode extends Backbone.Node

  requires:
    profile: 'profile'
    # component: 'component'

  initialize: ->
    @preview_view = new PreviewView
    $('#profile_preview_view').html @preview_view.render().el
    make_it_draggable()

  ready: ->
    @listenTo @preview_view, 'profile:activetype', @addComponent
    @listenTo @preview_view, 'deactive:component', @deactiveComponent
    @listenTo @profile, 'preview_view:show:component', @previewShowComponent
    @listenTo @profile, 'show:component', @showComponent
    @listenTo @preview_view, 'profile:save:components', @saveComponents
    @listenTo @profile, 'prepare:profile', @prepareComponents
    @listenTo @profile, 'profile:found', @found

    @listenTo @preview_view, 'show:component', @showComponent

  found: (profile) ->
    @profile.deactiveComponent()
    @profile.renderComponents @preview_view.$("#components ul.ui-components-list"), profile, true

  prepareComponents: ->
    @preview_view.saveComponents()

  saveComponents: (components) ->
    @profile.saveComponents components

  previewShowComponent: (option) ->
    # console.log option
    currentEl = @preview_view.$('.active-component')
    currentEl.data 'component-option', option

  showComponent: (option) ->
    # console.log option
    currentEl = @preview_view.$('.active-component')
    # console.log currentEl
    @profile.renderComponent currentEl, option


    # $text = @preview_view.$ '.text-component-render'
    #  textOption =
    #   type: 'text'
    #   template: 'hello everyone, text here!'

    # @profile.renderComponent $text, textOption

    # $canvas = @preview_view.$ '.chart-component-render'
    # canvasOption =
    #  type: 'chart'
    #   echarts: require '../chart_test_option'

    # @profile.renderComponent $canvas, canvasOption

    # $table = @preview_view.$ '.table-component-render'
    # tableOption =
    #  type: 'table'
    #   data:[
    #    year: 2011
    #     value: 10
    #   ,
    #    year: 2022
    #     value: 20
    #   ]
    #   template: 'hello everyone, table here!'

    # @profile.renderComponent $table, tableOption

  # sortComponent: ->
  #  order = @preview_view.getOrder()
  #  @profile.sortComponent order

  # removeComponent: ->
  #  @profile.removeActiveComponent()

  # addComponent: ($el,type,data,option) ->
  #   switch type
  #     when 'text' then @renderTextComponent $el, data, option
  #     when 'chart' then @renderChartComponent $el, data, option
  #     when 'table' then @renderTableComponent $el, data, option

  addComponent:(option) ->
    # console.log @profile
    @profile.addComponent option

    this

  deactiveComponent: ->
    @profile.deactiveComponent()

  # renderTextComponent:($el, data, option) ->
  #   @component.exports.text $el, option

  # renderChartComponent:($el, data, option) ->
  #   @component.exports.chart $el, option

  # renderTableComponent:($el, data, option) ->
  #   @component.exports.table $el, option







