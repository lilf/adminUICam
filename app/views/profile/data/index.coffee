DataView = require './data_view'

module.exports = class DataNode extends Backbone.Node

  requires:
    profile: 'profile'

  initialize: ->
    @data_view = new DataView
    @listenTo @data_view, 'profile:save:variables', @saveVariables
    $('#profile_data_view').html @data_view.render().el
    @data_view.codeMirror().enableJSONEdit()

  ready: ->
    @listenTo @profile, 'add:indicator_id:variable', @addIndicatorVar
    @listenTo @profile, 'preview_view:show:component', @showComponent
    @listenTo @profile, 'prepare:profile', @prepareVariables
    @listenTo @profile, 'profile:found', @found

  found: (profile) ->
    @data_view.addVars profile.profile.variables

  prepareVariables: ->
    @data_view.saveVar()

  showComponent: (option) ->
    variables = $.extend true, [], @data_view.editor.getValue()
    @profile.showComponent option, variables

  addIndicatorVar: (indicator_id) ->
    name = _.uniqueId 'indicator'
    type = indicator_id + ' | getIndicator'
    @data_view.addVar (name: name, type: type), true, true

  saveVariables: (variables) ->
    @profile.saveVariables variables

  addData: (data, name) ->
    @profile.addData data, name

  deleteData: (name) ->
    @profile.deleteData name

  editData: (name) ->
    @profile.editData name

