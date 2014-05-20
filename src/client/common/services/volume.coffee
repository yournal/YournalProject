module = mean.module 'yournal.services'

module.factory 'Volume', [
  '$resource',
  ($resource) ->


    createVolume: () ->
      $resource module.mean.asset('other/json/sections.json'), {},
        query:
          method: 'POST'

]
