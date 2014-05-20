module = mean.module 'yournal.admin.volume'

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('volume-new',
      url: '/admin/volume/new'
      templateUrl: module.mean.resource('admin/volume/admin-volume-new.html')
      controller: module.mean.namespace('VolumeCtrl')
      data:
        access:
          allow: ['admin']
          state: 'login'
    )
]

module.controller module.mean.namespace('VolumeCtrl'), [
  '$scope',
  'Volume',
  ($scope) ->
    $scope.year = new Date().getFullYear()
    $scope.maxYear = $scope.year
]
