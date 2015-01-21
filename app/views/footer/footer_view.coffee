module.exports = class FooterView extends Backbone.View

  template: require './templates/footer'

  className: 'uk-text-center uk-margin-top'

  render: ->
    @$el.html @template()

    this
