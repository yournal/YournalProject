module = mean.module 'yournal.services'

module.factory 'Issue', [
  '$resource',
  ($resource) ->
    getIssues: () ->
      data = $resource module.mean.asset('other/json/issues.json'), {},
        query:
          method: 'GET'
          isArray: true
      data.query()
    getIssue: (id) ->
      data = $resource module.mean.asset("other/json/issues/#{id}.json"), {},
        query:
          method: 'GET'
      data.get()
]
