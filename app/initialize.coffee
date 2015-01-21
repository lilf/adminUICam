config = require 'config'
Domain = require 'domain'
nodes = require 'nodes'
$ ->
  me = Backbone.oauth2 config.oauth
  jade.t = (x) -> x
  me.on 'me:login', (me, callback) ->

    if _.contains me.get('permissions'), 'cam_admin_ui'
      domain = new Domain nodes
      domain.login me
      callback()

    else
      alert 'you have no permission to enter this page.'
      me.logout()

  me.checkin()

  # domain = new Domain nodes
  # me = new Backbone.Model username: 'chipeng'
  # me.id = -1
  # domain.login me
  # Backbone.history.start()
