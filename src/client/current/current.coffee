module = angular.module 'yournal.current', [
  'yournal.services'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('home',
      url: '/'
      templateUrl: 'public/yournal/js/current/current-home.html'
      controller: 'yournal.current.HomeCtrl'
      resolve:
        loading: ['$rootScope', ($rootScope) ->
          $rootScope.loading = true
        ]
        journal: ['Journal', (Journal) ->
          Journal.get().$promise
        ]
        issues: ['Issue', (Issue) ->
          Issue.query(sort: ['year', 'volume', 'number'], order: -1, limit: 1).$promise
        ]
    )
    $stateProvider.state('current',
      url: '/current'
      templateUrl: 'public/yournal/js/current/current.html'
      controller: 'yournal.current.CurrentCtrl'
      resolve:
        issues: ['$rootScope', 'Issue', ($rootScope, Issue) ->
          $rootScope.loading = true
          Issue.query(sort: ['year', 'volume', 'number'], order: -1, limit: 1).$promise
        ]
    )
]

module.controller 'yournal.current.CurrentCtrl', [
  '$rootScope',
  '$scope',
  'issues',
  'User',
  ($rootScope, $scope, issues, User) ->
    $scope.user = User

    if issues.length > 0
      $scope.issue = issues[0]

    $scope.deleteSection = (sectionIndex) ->
      $scope.issue.sections.splice sectionIndex, 1

    $scope.deleteArticle = (sectionIndex, articleIndex) ->
      $scope.issue.sections[sectionIndex].articles.splice articleIndex, 1
]

module.controller 'yournal.current.HomeCtrl', [
  '$rootScope',
  '$scope',
  'journal',
  'issues',
  'User',
  ($rootScope, $scope, journal, issues, User) ->
    $scope.journal = journal
    $scope.user = User

    if issues.length > 0
      $scope.issue = issues[0]

    $scope.deleteSection = (sectionIndex) ->
      $scope.issue.sections.splice sectionIndex, 1

    $scope.deleteArticle = (sectionIndex, articleIndex) ->
      $scope.issue.sections[sectionIndex].articles.splice articleIndex, 1
]
