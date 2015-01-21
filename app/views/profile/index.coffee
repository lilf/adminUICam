ProfileView = require './profile_view'

profileGetter = require './profile'

methods = require './methods'

rule = require 'views/template/rule'

module.exports = class ProfileNode extends Backbone.Node

  defines:
    profile: 'profile'

  initialize: ->
    @profile = profileGetter()
    @profile_view = new ProfileView
    $('#main_view').html @profile_view.render().el

    @listenTo @profile, 'profile:notfound', @notfound
    @listenTo @profile, 'profile:create', @logCreate
    @listenTo @profile, 'profile:update', @logUpadte
    @listenTo @profile, 'profile:get:profile', @getProfileByName

  notfound: ->
    alert 'profile not found'

  logCreate: (model) ->
    @domainPub 'log', 'create', 'profile', model.id, model.toJSON()

  logUpadte: (model) ->
    @domainPub 'log', 'update', 'profile', model.id, model.toJSON()


  getProfileByName: (indicator_name) ->
    methods
    .getIndicator indicator_name
    .then (info) =>
      profile =
        indicator_id: null
        profile:
          variables: []
          components: []

      rule info, profile, => @profile.trigger 'profile:found', profile

