module = mean.module 'yournal.admin.issue'

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('issue-new',
      url: '/admin/issue/new'
      templateUrl: module.mean.resource('admin/issue/admin-issue-new.html')
      controller: module.mean.namespace('IssueNewCtrl')
      data:
        access:
          allow: ['admin']
          state: 'login'
    )
    $stateProvider.state('issue-edit',
      url: '/admin/issue/edit/:year/:volume/:number'
      templateUrl: module.mean.resource('admin/issue/admin-issue-edit.html')
      controller: module.mean.namespace('IssueEditCtrl')
      data:
        access:
          allow: ['admin']
          state: 'login'
    )
]

module.controller module.mean.namespace('IssueEditCtrl'), [
  '$scope',
  '$stateParams',
  'Issue',
  ($scope, $stateParams, Issue) ->
    $scope.year = parseInt($stateParams.year)
    $scope.volume = parseInt($stateParams.volume)
    $scope.number = parseInt($stateParams.number)
    $scope.maxYear = new Date().getFullYear()
    $scope.error = []
    $scope.response = null

    $scope.updateIssue = () ->
      Issue.update
        year: $scope.year
        volume: $scope.volume
        number: $scope.number
      ,
        (response) ->
          $scope.response = response
          $scope.error = []
          $scope.volume = null
          $scope.number = null
      ,
        (err) ->
          $scope.response = null
          if typeof err.data isnt 'object'
            $scope.error = [msg: err.data]
          else
            $scope.error = err.data

]

module.controller module.mean.namespace('IssueNewCtrl'), [
  '$scope',
  'Issue',
  ($scope, Issue) ->
    $scope.year = new Date().getFullYear()
    $scope.maxYear = $scope.year
    $scope.error = []
    $scope.response = null

    $scope.createIssue = () ->
      Issue.update
        year: $scope.year
        volume: $scope.volume
        number: $scope.number
      ,
        (response) ->
          $scope.response = response
          $scope.error = []
          $scope.volume = null
          $scope.number = null
      ,
        (err) ->
          $scope.response = null
          if typeof err.data isnt 'object'
            $scope.error = [msg: err.data]
          else
            $scope.error = err.data

]
