controller = ($scope, Journal, Article, Section) ->
  $scope.journals = Journal.query()
  $scope.articles = Article.query()
  $scope.sections = Section.query()

app = angular.module 'yournal.controllers'
app.controller 'ExampleController', [
  '$scope', 'Journal', 'Article', 'Section', controller
]