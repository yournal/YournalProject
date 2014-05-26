module = mean.module 'yournal.admin.issue'

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('issue-new',
      url: '/admin/issue/new'
      templateUrl: module.mean.resource('admin/issue/admin-issue-new.html')
      controller: module.mean.namespace('NewCtrl')
      data:
        access:
          allow: ['admin']
          state: 'login'
    )
    $stateProvider.state('issue-edit',
      url: '/admin/issue/edit/:year/:volume/:number'
      templateUrl: module.mean.resource('admin/issue/admin-issue-edit.html')
      controller: module.mean.namespace('EditCtrl')
      data:
        access:
          allow: ['admin']
          state: 'login'
    )
]

module.controller module.mean.namespace('NewCtrl'), [
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

module.controller module.mean.namespace('EditCtrl'), [
  '$scope',
  '$state',
  '$stateParams',
  'Issue',
  ($scope, $state, $stateParams, Issue) ->
    year = parseInt($stateParams.year)
    volume = parseInt($stateParams.volume)
    number = parseInt($stateParams.number)

    $scope.year = year
    $scope.volume = volume
    $scope.number = number
    $scope.maxYear = new Date().getFullYear()
    $scope.error = []
    $scope.response = null

    $scope.updateIssue = () ->
      Issue.update
        year: year
        volume: volume
        number: number
      ,
        year: $scope.year
        volume: $scope.volume
        number: $scope.number
      ,
        (response) ->
          $scope.response = response
          year = $scope.year
          volume = $scope.volume
          number = $scope.number

          $state.go 'issue-edit',
            year: year
            volume: volume
            number: number

          $scope.error = []
      ,
        (err) ->
          $scope.response = null
          $scope.year = year
          $scope.volume = volume
          $scope.number = number

          if typeof err.data isnt 'object'
            $scope.error = [msg: err.data]
          else
            $scope.error = err.data
]

module.controller module.mean.namespace('DeleteCtrl'), [
  '$scope',
  '$rootScope',
  '$state',
  '$stateParams',
  'Issue',
  'Message',
  ($scope, $rootScope, $state, $stateParams, Issue, Message) ->
    $scope.delete = (year, volume, number, redirect) ->
      data =
        year: parseInt year
        volume: parseInt volume
        number: parseInt number
      Issue.delete(
        data
      ,
        (response) ->
          Message.add
            success: true
            msg: 'Issue successfully deleted.'

          if redirect
            if redirect is 'reload'
              $state.go($state.current, $stateParams,
                reload: true
                inherit: false
                notify: true
              )
            else if redirect is 'previous'
              $state.go $state.previous
            else
              $state.go redirect
      ,
        (err) ->
          if err.data?
            err = err.data
            if err.err?
              if err.err.msg?
                err = err.err.msg
              else
                err = 'Unkown error.'
          Message.add
            success: false
            msg: err
      )
]
