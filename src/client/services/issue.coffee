service = ($resource) ->
  return $resource 'json/issues/:issueId.json', {}, {
    query:
      method: 'GET'
      isArray: true
  }

app = angular.module 'yournal.services'
app.factory 'Issue', ['$resource', service]