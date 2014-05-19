module = meanstack.module 'yournal.archives', [
  'yournal.services'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('archives',
      url: '/archives'
      templateUrl: module.mean.resource('archives/archives.html')
      controller: module.mean.module('ArchivesCtrl')
    )
]

module.controller module.mean.module('ArchivesCtrl'), [
  '$scope',
  'Issue',
  ($scope, Issue) ->
    $scope.issues = Issue.getIssues()
]
