service = ($resource) ->
  return $resource 'json/journals/:journal_id.json', {}, {
    query:
      method: 'GET'
      params: {journal_id: 'journals'}
      isArray: true
  }

app = angular.module 'yournal.services'
app.factory 'Journal', ['$resource', service]
