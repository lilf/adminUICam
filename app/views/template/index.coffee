TemplateView = require './template_view'
LittleRuleView = require './little_rule_view'

Templates = require 'models/templates'

module.exports = class TemplateNode extends Backbone.Node

  initialize: ->
    @templates = new Templates

    @template_view = new TemplateView
    $('#main_view').html @template_view.render().el

    @little_rule_view = new LittleRuleView collection: @templates
    $('#little_rule_view').html @little_rule_view.render().el

    @templates.fetch()
