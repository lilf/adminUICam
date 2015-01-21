module.exports = class DataView extends Backbone.View

  template: require './templates/data'

  events:
    'click button': 'saveVar'
    'click button.beautify-option': 'beautify'
    'changes #editor_holder_json': 'syncVariables2JSONEditor'
    'click button.fullscreen': 'fullScreen'

  render: ->
    @$el.html @template()
    @target = 'jsonEditor'

    this

  evaluate: (json_string) ->
    try
      return (new Function('return ' + json_string))()
    catch e
      # ...

  # getActiveEditor: ->
  #   index = $('[data-uk-switcher] li.uk-active').index()
  #   if index is 1
  #     'codeEditor'
  #   else
  #     'jsonEditor'

  jSONEditorChangeHandler: =>
    @disableIndicatorVariables()
    @setValue @editor.getValue() if @target is 'jsonEditor'

  syncVariables2JSONEditor: =>
    return unless @target is 'codeEditor'
    value = @myCodeMirror.getValue()
    value = @evaluate value
    return unless _.isArray(value) and _.every(value, (d) -> d.name and d.type)
    @addVars value

  syncHandler: (e) ->
    switch e
      when 'jsonEditor'
        @jSONEditorChangeHandler()

      when 'codeEditor'
        @syncVariables2JSONEditor()

  saveVar: ->
    @trigger 'profile:save:variables', @editor.getValue()

  addVars: (vars = []) ->
    @editor.setValue vars
    @setValue '[]' if _.isEmpty vars
    # _.map vars, @addVar, this

  addVar: (obj = {}, first = false, disable = false) ->
    value = @editor.getValue()

    return unless obj.name and obj.type

    findSameType = _.find value, (d) -> d.type is obj.type

    return if findSameType

    method = if first then 'unshift' else 'push'
    value[method] obj
    @editor.setValue value


  disableIndicatorVariables: =>
    value = @editor.getValue()
    for d, i in value
      if /getIndicator$/.test d.type
        @editor.getEditor('root.' + i).disable()
      else
        @editor.getEditor('root.' + i).enable()


  enableJSONEdit: ->
    editor_holder = @$('#editor_holder')[0]
    window.abceditor = @editor = new JSONEditor editor_holder,
      no_additional_properties: true
      disable_edit_json: true
      disable_properties: true
      iconlib: "uikit"
      schema:
        type: "array"
        # format: "tabs"
        title: "Variables"
        uniqueItems: true
        items:
          type: "object"
          title: "Var"
          properties:
            name:
              type: "string"

            type:
              type: "string"

        default: [
          name: "Walter"
          type: "dog"
        ]

    @editor.on 'change', => @syncHandler 'jsonEditor'

    this

  codeMirror: ->
    editor_holder_json = @$('#editor_holder_json')[0]
    @myCodeMirror = CodeMirror editor_holder_json,
      # value: "// please delete this line"
      lineNumbers: true
      mode: "application/json"
      gutters: ["CodeMirror-lint-markers"]
      lint: true
      keyMap: "sublime"
      autoCloseBrackets: true
      matchBrackets: true
      showCursorWhenSelecting: true
      theme: "monokai"
      extraKeys:
        F11: (cm) -> cm.setOption "fullScreen", not cm.getOption("fullScreen")
        Esc: (cm) -> cm.setOption "fullScreen", false  if cm.getOption("fullScreen")

    @myCodeMirror.on 'changes', => @syncHandler 'codeEditor'
    @myCodeMirror.on 'focus', => @target = 'codeEditor'
    @myCodeMirror.on 'blur', => @target = 'jsonEditor'

    this

  setValue: (value) ->
    unless _.isString value
      try
        value = JSON.stringify value, null, 2
      catch e
        alert e.message

    @myCodeMirror.setValue value

  beautify: ->
    beautified = js_beautify @myCodeMirror.getValue()
    @setValue beautified

  fullScreen: ->
    @myCodeMirror.focus()
    @myCodeMirror.setOption "fullScreen", true
