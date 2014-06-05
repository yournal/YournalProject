module = angular.module 'yournal.services'

module.factory 'Journal', [
  '$resource',
  ($resource) ->
    $resource 'api/journal/',
    {},
    update:
      method: 'PUT'
]
