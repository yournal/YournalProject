service = ($resource) ->
  return $resource 'json/sections.json', {}, {
    query:
      method: 'GET'
      isArray: true
  }

app = angular.module 'yournal.services'
app.factory 'Section', ['$resource', service]