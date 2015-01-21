module.exports = class RelationRuleView extends Backbone.View

  template: require './templates/relation_rule'

  render: ->
    @$el.html @template()

    this
