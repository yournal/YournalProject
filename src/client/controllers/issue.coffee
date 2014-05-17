controller = ($scope, $stateParams, Issue, Issues, Article, Section) ->
  $scope.issues = Issues.query()
  $scope.issue = Issue.get({issueId: $stateParams.issueId})
  $scope.articles = Article.query()
  $scope.sections = Section.query()

app = angular.module 'yournal.controllers'
app.controller 'IssueController', [
  '$scope', '$stateParams', 'Issue', 'Issues', 'Article', 'Section', controller
]