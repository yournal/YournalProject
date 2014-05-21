module = mean.module 'yournal.services'

module.factory 'Issue', [
  '$resource',
  ($resource) ->
    $resource 'api/issues/:year/:volume/:number',
      year: '@year'
      volume: '@volume'
      number: '@number'
    ,
    update:
      method: 'PUT'
]
