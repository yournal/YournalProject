module = angular.module 'yournal.issue', [
  'yournal.services',
  'yournal.admin.section',
  'yournal.admin.article'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('issue',
      url: '/issue/:year/:volume/:number'
      templateUrl: 'public/yournal/js/issue/issue.html'
      controller: 'yournal.issue.IssueCtrl'
      resolve:
        issue: ['$rootScope', '$state', '$stateParams', 'Issue',
          ($rootScope, $state, $stateParams, Issue) ->
            $rootScope.loading = true
            issue = Issue.get
              year: $stateParams.year
              volume: $stateParams.volume
              number: $stateParams.number
            , (response) ->
              return
            ,
              (err) ->
                $state.go('404')
            return issue.$promise
        ]
    )
]

module.controller 'yournal.issue.IssueCtrl', [
  '$rootScope',
  '$scope',
  '$state',
  'issue',
  'User',
  ($rootScope, $scope, $state, issue, User) ->
    $scope.issue = issue
    $scope.user = User

    $scope.deleteSection = (sectionIndex) ->
      $scope.issue.sections.splice sectionIndex, 1

    $scope.deleteArticle = (sectionIndex, articleIndex) ->
      $scope.issue.sections[sectionIndex].articles.splice articleIndex, 1
]
