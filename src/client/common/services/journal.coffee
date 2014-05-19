module = mean.module 'yournal.services'

module.factory 'Journal', [
  '$resource',
  ($resource) ->
    getJournal: () ->
      data = $resource module.mean.asset('other/json/journal.json'), {},
        query:
          method: 'GET'
      data.get()
]
