module = mean.module 'yournal.services'

module.factory 'Article', [
  '$resource',
  ($resource) ->
    $resource 'api/issues/:year/:volume/:number/sections/:section/articles/:article',
      year: '@year'
      volume: '@volume'
      number: '@number'
      section: '@section'
      article: '@article'
    ,
      all:
        url: 'api/articles'
        method: 'GET'
        isArray: true
]
