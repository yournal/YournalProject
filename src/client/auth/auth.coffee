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
    $stateProvider.state('logout',
      url: '/logout'
      controller: module.mean.namespace('LogoutCtrl')
      data:
        access:
          allow: ['authorized']
          state: 'home'
    )
    $stateProvider.state('register',
      url: '/register'
      templateUrl: module.mean.resource('auth/auth-register.html')
      data:
        access:
          deny: ['authorized']
          state: 'home'
    )
]

module.controller module.mean.namespace('LogoutCtrl'), [
  '$rootScope',
  '$location',
  '$http',
  'User',
  ($rootScope, $location, $http, User) ->
    $http.delete('/logout').success((response) ->
      User.remove()
      $rootScope.$emit 'loggedOut'
      $location.url '/'
    )
]

module.controller module.mean.namespace('LoginCtrl'), [
  '$window',
  '$scope',
  '$rootScope',
  '$http',
  '$location',
  'User',
  ($window, $scope, $rootScope, $http, $location, User) ->
    $scope.user = {}
    $scope.login = () ->
      $http.post('/login',
        email: $scope.user.email
        password: $scope.user.password
      ).success((response) ->
        $scope.loginError = 0
        if response isnt 'unauthorized'
          User.set response
          $rootScope.$emit 'loggedIn'
        else
          User.remove()
          $rootScope.$emit 'loggedOut'
        $location.url '/'
      ).error(() ->
        $scope.loginerror = 'Authentication failed.'
      )
]

module.controller module.mean.namespace('RegisterCtrl'), [
  '$window',
  '$scope',
  '$rootScope',
  '$http',
  '$location',
  'User',
  ($window, $scope, $rootScope, $http, $location, User) ->
    $scope.user = {}
    $scope.register = () ->
      $scope.registerError = null
      $http.post('/register',
        firstName: $scope.user.firstName
        lastName: $scope.user.lastName
        email: $scope.user.email
        password: $scope.user.password
        confirmPassword: $scope.user.confirmPassword
      ).success((response) ->
        $scope.registerError = 0
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
          $location.url '/'
        )
      ).error((err) ->
        if typeof err isnt 'object'
          $scope.registerError = [msg: err]
        else
          $scope.registerError = err
      )
]
