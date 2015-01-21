module.exports = class LinkView extends Backbone.View

  template: require './templates/link'

  tagName: 'li'

  events:
    'click': 'active'

  initialize: ->
    @listenTo @model, 'show:link', @show

  render: ->
    @$el.html @template @model.toJSON()
    @$el.addClass 'uk-active' if @model.get 'active'

    this

  show: ->
    uk_switcher = @$el.closest('[data-uk-switcher]')
    # why switcher not exist in the moment
    switcher = uk_switcher.data("switcher") or $.UIkit.switcher(uk_switcher, $.UIkit.Utils.options(uk_switcher.attr("data-uk-switcher")))
    switcher.show @el

  active: ->
    @model.trigger 'active:link', @model
