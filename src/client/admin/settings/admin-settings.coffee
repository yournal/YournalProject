module = mean.module 'yournal.admin.settings'

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('settings',
      url: '/admin/settings'
      templateUrl: module.mean.resource('admin/settings/admin-settings.html')
      controller: module.mean.namespace('SettingsCtrl')
      data:
        access:
          allow: ['admin']
          state: 'login'
      resolve:
        journal: ['$rootScope', 'Journal', ($rootScope, Journal) ->
          $rootScope.loading = true
          Journal.get().$promise
        ]
    )
]

module.controller module.mean.namespace('SettingsCtrl'), [
  '$scope',
  'journal'
  ($scope, journal) ->
    $scope.journal = journal

    $scope.save = ->
      $scope.journal.$update(
        (response) ->
          $scope.response = response
          $scope.error = []
          $scope.journal = response
        ,
        (err) ->
          $scope.response = null
          if typeof err.data isnt 'object'
            $scope.error = [msg: err.data]
          else
            $scope.error = err.data
      )
]
