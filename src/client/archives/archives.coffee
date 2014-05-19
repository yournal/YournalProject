module = mean.module 'yournal.archives', [
  'yournal.services'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('archives',
      url: '/archives'
      templateUrl: module.mean.resource('archives/archives.html')
      controller: module.mean.namespace('ArchivesCtrl')
    )
]

module.controller module.mean.namespace('ArchivesCtrl'), [
  '$scope',
  'Issue',
  ($scope, Issue) ->
    $scope.issues = Issue.getIssues()
]
