module.exports = class PreviewView extends Backbone.View

  template: require './templates/preview'

  events: ->
   'profile:active #components li': 'drop'
   'deactive:component #components li': 'deactive'
   'click #components li': 'select'
   'click button':'saveComponents'

  # addComponents: (components) ->
  #   @$("#components").empty()
  #   _.each components, @addComponent, this

  # addComponent: (component) ->
  #   @$("#components li.active-component").removeClass 'active-component'
  #   $('<li>')
  #   .appendTo @$("#components")
  #   .data 'component-option', component
  #   .addClass 'active-component'
  #   .trigger 'profile:active'

  saveComponents: ->
    components = _.map @$("#components li"), (li) -> $(li).data 'component-option'
    @trigger 'profile:save:components', components

  deactive: ->
    @trigger 'deactive:component'

  select: (e) ->
    $target = $ e.currentTarget
    # console.log $target.siblings()
    $target.parent().children().removeClass('active-component')
    $target.addClass('active-component')
    $target.trigger 'profile:active'
    # @trigger option_view, 'option_view:show:option'

  drop: (e) ->
    $target = $ e.currentTarget
    option = $target.data 'component-option'
    option = e.currentTarget.firstChild.id unless option

    # console.log e.currentTarget.firstChild.id
    @trigger 'profile:activetype', option
    # this

  render: ->
    @$el.html @template()

    this
