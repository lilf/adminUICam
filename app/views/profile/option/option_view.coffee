module.exports = class OptionView extends Backbone.View

  template: require './templates/option'

  events:
    'click button.save-option': 'save'
    'click button.beautify-option': 'beautify'
    'click button.copy-option': 'copy'
    'click button.fullscreen': 'fullScreen'

  render: ->
    @$el.html @template()
    @myTextArea = @$('textarea')[0]

    this

  codeMirror: ->
    @myCodeMirror = CodeMirror @el,
      # value: "function myScript(){return 100;}\n"
      lineNumbers: true
      mode: "javascript"
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

  setValue: (value = '') ->
    @myCodeMirror.setValue value

  save: ->
    # try
    #   option_string = @myCodeMirror.getValue()
    #   option = (new Function('return ' + option_string))()
    #   @trigger 'save:component:option', option
    # catch e
    #   alert 'error happened: ' + e.message

      option_string = @myCodeMirror.getValue()

      ######## old implement
      # option = (new Function('return ' + option_string))()
      # @trigger 'save:component:option', option
      ######## new implement
      @trigger 'save:component:option', option_string

  copy: ->
    @copyToClipboard @myCodeMirror.getValue()

  copyToClipboard: (text) ->
    temp_component = localStorage.getItem 'temp_component'
    temp_component_json = if temp_component then JSON.parse temp_component else []
    return alertify.error 'already copied' if _.contains temp_component_json, text
    temp_component_json.push text
    temp_component = JSON.stringify temp_component_json, null, 2
    localStorage.setItem 'temp_component', temp_component
    alertify.success 'component option copyed'

  beautify: ->
    beautified = js_beautify @myCodeMirror.getValue()
    @setValue beautified

  fullScreen: ->
    @myCodeMirror.focus()
    @myCodeMirror.setOption "fullScreen", true
