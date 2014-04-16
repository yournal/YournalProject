controller = ($scope, Journal, Article) ->
  $scope.journals = Journal.query()
  $scope.articles = Article.query()
  $scope.someaction = ->
    return 'Testing controller action'

app = angular.module 'yournal.controllers', []
app.controller 'ExampleController', [
  '$scope', 'Journal', 'Article', controller
]