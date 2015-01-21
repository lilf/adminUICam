
Templates = require 'models/templates'

templates = new Templates

# get one little rule

littleRule = ->


# get one profile
bigRule = ->

# get the best profile
relation = ->


findName = (name) ->
  _.where templates.toJSON(), {name}

findMatch = (ts, name) ->
  _.filter ts, (t) ->
    # re = new RegExp '(' + name + ')'
    # re.test t.name
    t.mode is name

findMode = (info) ->
  ts = templates.toJSON()
  _.chain info
    .keys()
    .map (key) -> findMatch ts, key
    .flatten()
    .sortBy 'order'
    .value()

fillProfileVaraibles = (profile, ts) ->
  _.map ts, (t) ->
    for variable in t.profile.variables
      {name} = variable
      continue if _.findWhere profile.profile.variables, {name}
      profile.profile.variables.push variable

fillProfileComponents = (profile, ts) ->
  _.map ts, (t) ->
    profile.profile.components.push t.profile.components...

fillButtonGroupComponent = (profile, ts) ->
  return if _.isEmpty ts

  modes = _.map ts, (t) -> _.pick t, 'name'

  option =
    type: 'buttongroups'
    test: false
    modes: modes

  button_group = JSON.stringify option, null, 2

  profile.profile.components.push button_group

fillIndicatorVariable = (profile, info) ->
  indicator_name = info.indicator.name
  profile.profile.variables.push
    name: 'ind'
    type: indicator_name + ' | getIndicator'

rule = (info, profile, callback) -> ->
  defaultTemplates = findName 'default'
  emptyTemplates = findName 'empty'
  modesTemplates = findMode info

  # varaibles
  ## add indicator variable
  fillIndicatorVariable profile, info

  ## add default
  fillProfileVaraibles profile, defaultTemplates

  ## add modesTemplates

  fillProfileVaraibles profile, modesTemplates

  # componnets

  ## add default
  fillProfileComponents profile, defaultTemplates

  ## if templates found
  unless _.isEmpty modesTemplates
  ## add button group
    fillButtonGroupComponent profile, modesTemplates

  ## add modesTemplates
    fillProfileComponents profile, modesTemplates

  ## else
  else
  ## add empty
    fillProfileComponents profile, emptyTemplates
  ## endif

  callback profile

module.exports = (info, profile, callback) ->
  templates.fetch().then rule info, profile, callback
