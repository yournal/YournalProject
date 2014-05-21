module = mean.module 'yournal.layout'

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('404',
      url: '/404'
      templateUrl: module.mean.resource('layout/layout-404.html')
    )
    $stateProvider.state('error',
      url: '/*resource'
      templateUrl: module.mean.resource('layout/layout-404.html')
    )
]

module.controller module.mean.namespace('HeaderCtrl'), [
  '$scope',
  '$rootScope',
  'User',
  ($scope, $rootScope, User) ->
    $scope.collapsed = true
    $scope.user = User
]
