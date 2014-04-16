service = ($resource) ->
  return $resource 'json/articles/:articleId.json', {}, {
    query:
      method: 'GET'
      params: {articleId: 'articles'}
      isArray: true
  }

app = angular.module 'yournal.services'
app.factory 'Article', ['$resource', service]