service = ($resource) ->
  return $resource 'json/issues.json', {}, {
    query:
      method: 'GET'
      isArray: true
  }

app = angular.module 'yournal.services'
app.factory 'Issues', ['$resource', service]