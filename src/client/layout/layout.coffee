module = mean.module 'yournal.layout'

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('404',
      url: '/*resource'
      templateUrl: module.mean.resource('layout/layout-404.html')
    )
]

module.controller module.mean.namespace('HeaderCtrl'), [
  '$scope',
  '$rootScope',
  'user',
  ($scope, $rootScope, user) ->
    $scope.collapsed = true
    $scope.user = user
]
