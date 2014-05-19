module = meanstack.module 'yournal.issue', [
  'yournal.services'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('issue',
      url: '/issue/:issueId'
      templateUrl: module.mean.resource('issue/issue.html')
      controller: module.mean.module('IssueCtrl')
    )
]

module.controller module.mean.module('IssueCtrl'), [
  '$scope',
  '$stateParams',
  'Issue',
  'Article',
  'Section',
  ($scope, $stateParams, Issue, Article, Section) ->
    $scope.issue = Issue.getIssue($stateParams.issueId)
    $scope.issues = Issue.getIssues()
    $scope.articles = Article.getArticles()
    $scope.sections = Section.getSections()
]
