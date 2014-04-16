service = ($resource) ->
  return $resource 'json/articles.json', {}, {
    query:
      method: 'GET'
      isArray: true
  }

app = angular.module 'yournal.services.article', ['ngResource']
app.factory 'Article', ['$resource', service]