component_divider = '\n//start=====do=====not=====component=====modify=====end\n'

componentsStringify = (components = []) ->
  components = (js_beautify d for d in components)
  components.join component_divider

componentsParse = (str) ->
  divider = _.string.trim component_divider
  components = str.split divider
  components = _.map components, (d) -> _.string.trim d
  _.compact components


module.exports = class LittleRuleView extends Backbone.View

  template: require './templates/little_rule'

  events:
    'change select': 'selectName'
    'click button.save-rule': 'save'
    'click button.destroy-rule': 'destroy'
    'click button.add-rule': 'add'
    'click button.edit-rule': 'destroy'
    'click button.paste-componnet': 'paste'

  initialize: ->
    @listenTo @collection, 'add', @renderItem
    @listenTo @collection, 'active', @activeItem

  render: ->
    @$el.html @template()
    @$select = @$ 'select[name=name]'
    @$new_name = @$ 'input[name=newname]'
    @$modename = @$ 'input[name=mode]'
    @$variables = @$ 'textarea.profile-variables-textarea'
    @$components = @$ 'textarea.profile-components-textarea'

    @initSelectize()

    this

  initSelectize: ->
    @$select.selectize
      valueField: 'name'
      labelField: 'name'
      sortField: 'order'

  renderItem: (model) ->
    template = model.toJSON()
    # option = $ '<option>', text: template.name, value: template.name
    # @$select
    # .append option
    @$select[0].selectize.addOption  template

  activeItem: (model) ->
    template = model.toJSON()
    { variables, components } = template.profile
    @$new_name.val template.name
    @$modename.val template.mode

    # just to ensure the order of attributes of variable is [name, type]
    variables = _.map variables, (d) ->
      {name, type} = d
      {name, type}

    @$variables.val JSON.stringify variables, null, 2
    # console.log components[0]
    @$components.val componentsStringify components

  selectName: ->
    @_selectName @$select.val()

  _selectName: (name) ->
    return @clean() if name is ''
    @model = @collection.findWhere { name }
    return unless @model
    @model.trigger 'active', @model

  save: ->
    json = @$el.toObject()
    {variables, components} = json.profile
    json.name = json.newname if json.newname
    json.profile.variables = JSON.parse variables
    json.profile.components = componentsParse components

    @model
    .save json
    .done -> alertify.success 'template saved'
    .fail -> alertify.error 'error happend when save'

  destroy: ->
    self = this
    $option = @$select.find('option[value="' + @model.get('name') + '"]')
    if @model.isNew()
      @collection.remove @model
      $option.remove()
      self.clean()
      alertify.success 'template destroyed'

    else
      @model
      .destroy()
      .done ->
        $option.remove()
        self.clean()
        alertify.success 'template destroyed'
      .fail -> alertify.error 'error happend when delete'

  clean: ->
    @$new_name.val ''
    @$modename.val ''
    @$variables.val ''
    @$components.val ''

  add: ->
    value = prompt 'please enter template name , eg. Trend(gender_value_year)', 'Trend(gender_value_year)'
    return if _.isEmpty value
    @collection.add name: value
    @$select.val value
    @_selectName value

  paste: ->
    component = localStorage.getItem 'temp_component'
    return unless component
    component = JSON.parse component
    localStorage.removeItem 'temp_component'
    components_val = @$components.val()
    components = componentsParse components_val
    components.push component...
    @$components.val componentsStringify components
