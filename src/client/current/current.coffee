module = mean.module 'yournal.current', [
  'yournal.services'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('home',
      url: '/'
      templateUrl: module.mean.resource('current/current-home.html')
      controller: module.mean.namespace('HomeCtrl')
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
      templateUrl: module.mean.resource('current/current.html')
      controller: module.mean.namespace('CurrentCtrl')
      resolve:
        issues: ['$rootScope', 'Issue', ($rootScope, Issue) ->
          $rootScope.loading = true
          Issue.query(sort: ['year', 'volume', 'number'], order: -1, limit: 1).$promise
        ]
    )
]

module.controller module.mean.namespace('CurrentCtrl'), [
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

module.controller module.mean.namespace('HomeCtrl'), [
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
