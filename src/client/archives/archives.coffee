module = mean.module 'yournal.archives', [
  'yournal.services',
  'yournal.admin.issue'
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
  '$rootScope',
  '$scope',
  'Issue',
  'User',
  ($rootScope, $scope, Issue, User) ->
    bind = ->
      $scope.issues = Issue.query(filter: 'sections')
    $scope.user = User
    $rootScope.$on 'rebind', ->
      bind()
    bind()
]
