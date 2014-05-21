module = mean.module 'yournal.issue', [
  'yournal.services'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('issue',
      url: '/issue/:year/:volume/:number'
      templateUrl: module.mean.resource('issue/issue.html')
      controller: module.mean.namespace('IssueCtrl')
    )
]

module.controller module.mean.namespace('IssueCtrl'), [
  '$scope',
  '$stateParams',
  'Issue',
  'Article',
  'Section',
  ($scope, $stateParams, Issue, Article, Section) ->
    $scope.issue = Issue.get
      year: $stateParams.year
      volume: $stateParams.volume
      number: $stateParams.number
]
