OptionView = require './option_view'

module.exports = class OptionNode extends Backbone.Node

  requires:
    profile: 'profile'

  initialize: ->
    @option_view = new OptionView
    $('#profile_option_view').html @option_view.render().el
    @option_view.codeMirror()
    @deactive()
    # @active 'text'

    @listenTo @option_view, 'save:component:option', @saveOption

  saveOption: (option) ->
    # save current active component option
    @profile.saveActiveOption option
    # console.log option

  ready: ->
    @listenTo @profile, 'profile:active', @active
    @listenTo @profile, 'profile:deactive', @deactive

  deactive: ->
    @option_view.setValue "// please drag a component first\n"

  active: (option) ->
    # console.log option
    option = @getOptionString option if _.contains ['text', 'chart', 'table', 'buttongroups'], option

    @option_view.setValue option
    # else
    #   # console.log option
    #   $.each @profile.content, (option) -> @option_view.setValue option


  getOptionString: (option) ->
    option = @getOption option
    option = JSON.stringify option, null, 2
    option

  getOption: (type) ->
    switch type
      when 'text' then @getTextOption()
      when 'chart' then @getChartOption()
      when 'table' then @getTableOption()
      when 'buttongroups' then @getButtonGroupOption()
      else ''

  getTextOption: ->
    json =
      type: 'text'
      template: '{{Walter}}'

  getChartOption: ->
    json =
      type: 'chart'
      width: '100%'
      height: '400'
      echarts: ''

  getTableOption: ->
    json =
      type: 'table'
      data: []

  getButtonGroupOption: ->
    json =
      type: 'buttongroups'
      test: true
      modes: [
        {
          name: "趨勢(gender-year-value)"
        },
        {
          name: "趨勢(gender-year-quarter-value)"
        },
        {
          name: "趨勢(gender-year-month-quarter-value)"
        },
        {
          name: "年齡(age-gender-year-value)"
        }]






