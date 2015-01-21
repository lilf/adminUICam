class Name extends Backbone.Model

  idAttribute: '_id'

module.exports = class Names extends Backbone.Collection

  model: Name

  comparator: 'order'
