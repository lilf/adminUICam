module.exports = class RawdataView extends Backbone.View

  template: require './templates/rawdata'

  render: ->
    @$el.html @template()

    this
