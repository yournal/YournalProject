service = ($resource) ->
  return $resource 'json/journals.json', {}, {
    query:
      method: 'GET'
      isArray: true
  }

app = angular.module 'yournal.services'
app.factory 'Journal', ['$resource', service]