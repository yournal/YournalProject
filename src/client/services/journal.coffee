service = ($resource) ->
  return $resource 'json/journals.json', {}, {
    query:
      method: 'GET'
      isArray: true
  }

app = angular.module 'yournal.services.journal', ['ngResource']
app.factory 'Journal', ['$resource', service]