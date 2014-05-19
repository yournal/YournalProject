module = mean.module 'yournal.services'

module.factory 'Section', [
  '$resource',
  ($resource) ->
    getSections: () ->
      data = $resource module.mean.asset('other/json/sections.json'), {},
        query:
          method: 'GET'
          isArray: true
      data.query()
]
