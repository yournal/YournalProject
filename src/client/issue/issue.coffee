module = mean.module 'yournal.issue', [
  'yournal.services',
  'yournal.admin.section',
  'yournal.admin.article'
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
  '$rootScope',
  '$scope',
  '$stateParams',
  'Issue',
  'User',
  ($rootScope, $scope, $stateParams, Issue, User) ->
    bind = ->
      $scope.issue = Issue.get
        year: $stateParams.year
        volume: $stateParams.volume
        number: $stateParams.number
    $scope.user = User
    $rootScope.$on 'rebind', ->
      bind()
    bind()
]
