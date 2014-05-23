module = mean.module 'yournal.auth', ['yournal.services']

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('login',
      url: '/login'
      templateUrl: module.mean.resource('auth/auth-login.html')
      controller: module.mean.namespace('LoginCtrl')
      data:
        access:
          deny: ['authorized']
          state: 'home'
    )
    $stateProvider.state('register',
      url: '/register'
      templateUrl: module.mean.resource('auth/auth-register.html')
      controller: module.mean.namespace('RegisterCtrl')
      data:
        access:
          deny: ['authorized']
          state: 'home'
    )
    $stateProvider.state('logout',
      url: '/logout'
      controller: module.mean.namespace('LogoutCtrl')
      data:
        access:
          allow: ['authorized']
          state: 'home'
    )
]

module.controller module.mean.namespace('LogoutCtrl'), [
  '$rootScope',
  '$state',
  '$http',
  'User',
  'Message',
  ($rootScope, $state, $http, User, Message) ->
    $http.delete('/logout').success((response) ->
      User.remove()
      $rootScope.$emit 'loggedOut'
      Message.add
        success: true
        msg: 'You are now logged out.'
        type: 'info'
      $state.go 'home'
    )
]

module.controller module.mean.namespace('LoginCtrl'), [
  '$rootScope',
  '$scope',
  '$state'
  '$http',
  'User',
  'Message',
  ($rootScope, $scope, $state, $http, User, Message) ->
    $scope.user = {}
    $scope.login = ->
      $http.post('/login',
        email: $scope.user.email
        password: $scope.user.password
      ).success((response) ->
        $scope.loginError = []
        if response isnt 'unauthorized'
          User.set response
          $rootScope.$emit 'loggedIn'
        else
          User.remove()
          $rootScope.$emit 'loggedOut'
        Message.add
          success: true
          msg: 'You are now logged in.'
        $state.go 'home'
      ).error((err) ->
        if typeof err isnt 'object'
          $scope.loginError = [msg: err]
        else
          if err.error?
            err = [msg: err.error.msg]
          $scope.loginError = err
      )
]

module.controller module.mean.namespace('RegisterCtrl'), [
  '$rootScope',
  '$scope',
  '$state',
  '$http',
  'User',
  'Message',
  ($rootScope, $scope, $state, $http, User, Message) ->
    $scope.user = {}
    $scope.register = ->
      $scope.registerError = []
      $http.post('/register',
        firstName: $scope.user.firstName
        lastName: $scope.user.lastName
        email: $scope.user.email
        password: $scope.user.password
        confirmPassword: $scope.user.confirmPassword
      ).success((response) ->
        $scope.registerError = []
        $rootScope.$emit 'registered'
        $http.post('/login',
          email: $scope.user.email
          password: $scope.user.password
        ).success((response) ->
          if response isnt 'unauthorized'
            User.set response
            $rootScope.$emit 'loggedIn'
          else
            User.remove()
            $rootScope.$emit 'loggedOut'
          Message.add
            success: true
            msg: 'You are now logged in.'
          $state.go 'home'
        )
      ).error((err) ->
        if typeof err isnt 'object'
          $scope.registerError = [msg: err]
        else
          if err.error?
            err = [msg: err.error.msg]
          $scope.registerError = err
      )
]
