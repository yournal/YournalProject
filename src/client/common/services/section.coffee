module = mean.module 'yournal.services'

module.factory 'Section', [
  '$resource',
  ($resource) ->
    $resource 'api/issues/:year/:volume/:number/sections',
      year: '@year'
      volume: '@volume'
      number: '@number'
]
