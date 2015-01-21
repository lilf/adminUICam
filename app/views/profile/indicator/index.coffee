IndicatorView = require './indicator_view'
Indicators = require 'models/indicators'

module.exports = class IndicatorNode extends Backbone.Node

  requires:
    profile: 'profile'

  initialize: ->
    @collection = new Indicators
    @indicator_view = new IndicatorView { @collection }
    $('#profile_indicator_view').html @indicator_view.render().el
    @listenTo @collection, 'save:profile', @saveProfile
    @listenTo @collection, 'set:profile:indicator_id', @setProfileIndicatorId
    @listenTo @collection, 'load:profile:indicator_id', @loadProfile
    @listenTo @collection, 'profile:add:variable', @addVar
    @listenTo @collection, 'profile:get:profile', @getProfile

  ready: ->
    @collection.fetch reset: true
    @listenTo @profile, 'prepare:profile', @prepareIndicatorId

  prepareIndicatorId: ->
    indicator_id = @indicator_view.getIndicatorId()
    @setProfileIndicatorId indicator_id

  saveProfile: ->
    @profile.save()

  loadProfile: (indicator_id) ->
    @profile.load indicator_id

  setProfileIndicatorId: (indicator_id) ->
    @profile.setIndicatorId indicator_id

  addVar: (indicator_id) ->
    indicator = @collection.get indicator_id
    name = indicator.get 'name'
    @profile.trigger 'add:indicator_id:variable', name

  getProfile: (indicator_id) ->
    indicator = @collection.get indicator_id
    name = indicator.get 'name'
    @profile.trigger 'profile:get:profile', name
