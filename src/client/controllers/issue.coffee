controller = ($scope, $stateParams, Issue, Article, Section) ->
  $scope.issue = Issue.get({issueId: $stateParams.issueId})
  $scope.articles = Article.query()
  $scope.sections = Section.query()

app = angular.module 'yournal.controllers'
app.controller 'IssueController', [
  '$scope', '$stateParams', 'Issue', 'Article', 'Section', controller
]