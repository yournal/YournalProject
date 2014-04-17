controller = ($scope, Article) ->
  $scope.articles = Article.query()
  $scope.query = {}
  $scope.query.result = '!'
  $scope.search = (query) ->
    if !(query?) || query.length == 0
      query = '!'
    $scope.query.result = query

app = angular.module 'yournal.controllers'
app.controller 'SearchController', [
  '$scope', 'Article', controller
]