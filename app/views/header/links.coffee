config = require 'config'

module.exports = [
  name: 'Log'
  href: '#log'
  selector: 'log'
,
  name: 'Import'
  href: '#import'
  selector: 'import'
,
  name: 'Meta'
  href: '#meta'
  selector: 'meta'
,
  name: 'Review'
  href: '#review'
  selector: 'review'
,
  name: 'Active'
  href: '#active'
  selector: 'active'
,
  name: 'Profile'
  href: '#profile'
  selector: 'profile'
,
  name: 'Template'
  href: '#template'
  selector: 'template'
  active: true
,
  name: 'Summary'
  href: '#summary'
  selector: 'summary'
,
  name: 'Translate'
  href: config.api.baseUrl + '/i18next'
  selector: 'translate'
]
