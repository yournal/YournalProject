service = ($resource) ->
  return $resource 'json/journal.json', {}, {
    query:
      method: 'GET'
  }

app = angular.module 'yournal.services'
app.factory 'Journal', ['$resource', service]