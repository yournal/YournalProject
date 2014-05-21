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
  'User',
  ($scope, Issue, User) ->
    $scope.issues = Issue.query(filter: 'sections')
    $scope.user = User


    $scope.deleteIssue = (issue) ->
      Issue.delete(
        year: issue.year
        volume: issue.volume
        number: issue.number
      , (response) ->
        $scope.err =
          success: true
          msg: 'Issue "' + response.year + ' (Vol. ' + response.volume + ' Num. ' + response.number + ')" successfully deleted.'
        $scope.issues = Issue.query(filter: 'sections')
      ,
        (err) ->
          console.log err
          $scope.err =
            success: false
            msg: 'There was an error. ' + err.data.err.msg
      )
]
