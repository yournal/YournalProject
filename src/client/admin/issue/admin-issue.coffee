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
      Issue.save
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
