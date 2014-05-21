module = mean.module 'yournal.issue', [
  'yournal.services'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('issue',
      url: '/issue/:year/:volume/:number'
      templateUrl: module.mean.resource('issue/issue.html')
      controller: module.mean.namespace('IssueCtrl')
    )
]

module.controller module.mean.namespace('IssueCtrl'), [
  '$scope',
  '$stateParams',
  'Issue',
  'Article',
  'Section',
  'User'
  ($scope, $stateParams, Issue, Article, Section, User) ->

    

    $scope.refreshIssue = () ->
      $scope.issue = Issue.get
        year: $stateParams.year
        volume: $stateParams.volume
        number: $stateParams.number

    $scope.deleteSection = (section) ->
      Section.delete(
        year: $stateParams.year
        volume: $stateParams.volume
        number: $stateParams.number
        section: section._id
      , (response) ->
        $scope.err =
          success: true
          msg: 'Section "' + response.title + '" successfully deleted.'
        $scope.refreshIssue()
      ,
        (err) ->
          console.log err
          $scope.err =
            success: false
            msg: 'There was an error. ' + err.data.err.msg
    )

    $scope.user = User
    $scope.refreshIssue()
]
