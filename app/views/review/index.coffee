Logs = require 'models/logs'
ReviewView = require './review_view'

SearchboxView = require './search_box_view'
ListView = require './list_view'

module.exports = class ReviewNode extends Backbone.Node

  initialize: ->
    @collection = new Logs
    @review_view = new ReviewView
    @search_box_view = new SearchboxView {@collection}
    @list_view = new ListView {@collection}

    $('#main_view').html @review_view.render().el
    $('#review_search_box_view').html @search_box_view.render().el
    $('#review_list_view').html @list_view.render().el

    @collection.getInfo()
