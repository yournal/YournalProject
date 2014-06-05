module = angular.module 'yournal.archives', [
  'yournal.services',
  'yournal.admin.issue'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('archives',
      url: '/archives'
      templateUrl: 'public/yournal/js/archives/archives.html'
      controller: 'yournal.archives.ArchivesCtrl'
      resolve:
        issues: ['$rootScope', 'Issue', ($rootScope, Issue) ->
          $rootScope.loading = true
          Issue.query(filter: 'sections').$promise
        ]
    )
]

module.controller 'yournal.archives.ArchivesCtrl', [
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
