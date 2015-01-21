module.exports = class SearchboxView extends Backbone.View

  template: require './templates/search_box'

  events:
    'click button.search-button': 'search'

  initialize: ->
    @listenTo @collection, 'log:info', @renderForm

  render: ->
    @$el.html @template()
    @$("[data-uk-margin]").ukMargin()

    this

  search: ->
    {start_date, end_date, username, type, table} = json = @$el.toObject()
    return if _.isEmpty json
    query = {}

    query.where = {} if username or type or table
    query.where.username = username if username
    query.where.type = type if type
    query.where.table = table if table

    if start_date
      query.gte = {}
      query.gte.created_at = ers.timeFromString start_date

    if end_date
      query.lte = {}
      query.lte.created_at = ers.timeFromString end_date

    @collection.search query

  renderForm: (data) ->
    @renderTimeRange data.times[0]
    @renderOptions 'username', data.usernames
    @renderOptions 'type', data.types
    @renderOptions 'table', data.tables

  renderTimeRange: (json) ->
    {created_at_min, created_at_max} = json
    min = ers.timeToLocaleString created_at_min
    max = ers.timeToLocaleString created_at_max
    @$('[name=created_at]').text min + ' - ' + max

  renderOptions: (name, collection) ->
    @.$ 'select[name=' + name + ']'
    .html @_renderOptions collection

  _renderOptions: (collection) ->
    array = collection
    array.unshift _id: '', name: 'None'
    array.map (json) ->
      json.name ?= json._id
      $ '<option>', value: json._id, text: json.name
