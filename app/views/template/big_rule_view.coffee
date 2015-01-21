module.exports = class BigRuleView extends Backbone.View

  template: require './templates/big_rule'

  render: ->
    @$el.html @template()

    this
