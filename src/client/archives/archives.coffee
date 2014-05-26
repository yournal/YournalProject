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
      resolve:
        issues: ['$rootScope', 'Issue', ($rootScope, Issue) ->
          $rootScope.loading = true
          Issue.query(filter: 'sections').$promise
        ]
    )
]

module.controller module.mean.namespace('ArchivesCtrl'), [
  '$rootScope',
  '$scope',
  'issues',
  'User',
  ($rootScope, $scope, issues, User) ->
    $scope.issues = issues
    $scope.user = User

    $scope.deleteIssue = (issueIndex) ->
      issues.splice issueIndex, 1
]
