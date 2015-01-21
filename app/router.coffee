module.exports = class Router extends Backbone.Router

  routes:
    '': 'log'
    'log': 'log'
    'import': 'import'
    'import/:name': 'import'
    'meta': 'meta'
    'review': 'review'
    'active': 'active'
    'profile': 'profile'
    'template': 'template'
    'summary': 'summary'
