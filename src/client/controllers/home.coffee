controller = ($scope, Journal, Issues, Article, Section) ->
  $scope.journal = Journal.query()
  $scope.issues = Issues.query()
  $scope.articles = Article.query()
  $scope.sections = Section.query()
  $scope.someaction = ->
    return 'Testing controller action'

app = angular.module 'yournal.controllers'
app.controller 'HomeController', [
  '$scope', 'Journal', 'Issues', 'Article', 'Section', controller
]