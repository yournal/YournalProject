module = mean.module 'yournal.current', [
  'yournal.services'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('home',
      url: '/'
      templateUrl: module.mean.resource('current/current-home.html')
      controller: module.mean.namespace('CurrentCtrl')
    )
    $stateProvider.state('current',
      url: '/current'
      templateUrl: module.mean.resource('current/current.html')
      controller: module.mean.namespace('CurrentCtrl')
    )
]

module.controller module.mean.namespace('CurrentCtrl'), [
  '$scope',
  'Journal',
  'Issue',
  'Error'
  ($scope, Journal, Issue, Error) ->
    $scope.journal = Journal.getJournal()
    issue = Issue.query(sort: ['year', 'volume', 'number'], order: -1, limit: 1)
    issue.$promise.then (data) ->
      if data.length > 0
        $scope.issue = data[0]
    $scope.errors = Error.get()
]
