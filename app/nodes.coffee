module.exports =
  header: require 'views/header'
  main: Backbone.Node
  footer: require 'views/footer'
  column: require 'views/column'
  mode: require 'views/mode'
  column_mode: require 'views/column_mode'
  category: require 'views/category'
  source: require 'views/source'
  indicator: require 'views/indicator'
  category_indicator: require 'views/category_indicator'
  upload: require 'views/upload'
  rawdata: require 'views/rawdata'
  summary: require 'views/summary'

  # profile
  profileDataNode: require 'views/profile/data'
  profilePreviewNode: require 'views/profile/preview'
  profileOptionNode: require 'views/profile/option'
  profileIndicatorNode: require 'views/profile/indicator'

  application:
    node: require 'views'
    children: ['header', 'main', 'footer']

  log:
    target: 'main'
    node: require 'views/log'
    params:
      el: '#main_view'

  review:
    target: 'main'
    node: require 'views/review'
    params:
      el: '#main_view'

  meta:
    target: 'main'
    node: require 'views/meta'
    params:
      el: '#main_view'

  active:
    target: 'main'
    node: require 'views/active'
    params:
      el: '#main_view'

  profile:
    target: 'main'
    node: require 'views/profile'
    children: [
      'profileIndicatorNode'
      'profileDataNode'
      'profilePreviewNode'
      'profileOptionNode'
    ]

  template:
    target: 'main'
    node: require 'views/template'

  summary:
    target: 'main'
    node: require 'views/summary'
    params:
      el: '#main_view'

  import:
    target: 'main'
    node: require 'views/import'
    children: [
      'column'
      'mode'
      'column_mode'
      'category'
      'source'
      'indicator'
      'category_indicator'
      'upload'
      'rawdata'
    ]
    params:
      el: '#main_view'

