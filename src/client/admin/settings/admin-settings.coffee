module = angular.module 'yournal.admin.settings', []

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('settings',
      url: '/admin/settings'
      templateUrl: 'public/yournal/js/admin/settings/admin-settings.html'
      controller: 'yournal.admin.settings.SettingsCtrl'
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

module.controller 'yournal.admin.settings.SettingsCtrl', [
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
