module = mean.module 'yournal.auth', ['yournal.services']

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('login',
      url: '/login'
      templateUrl: module.mean.resource('auth/auth-login.html')
      controller: module.mean.namespace('LoginCtrl')
      data:
        deny: ['authenticated']
    )
    $stateProvider.state('logout',
      url: '/logout'
      controller: module.mean.namespace('LogoutCtrl')
      data:
        allow: ['authenticated']
    )
    $stateProvider.state('register',
      url: '/register'
      templateUrl: module.mean.resource('auth/auth-register.html')
      data:
        deny: ['authenticated']
    )
]

module.controller module.mean.namespace('LogoutCtrl'), [
  '$rootScope',
  '$location',
  '$http',
  'user',
  ($rootScope, $location, $http, user) ->
    $http.delete('/logout').success((response) ->
      user.remove()
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
  'user',
  ($window, $scope, $rootScope, $http, $location, user) ->
    $scope.user = {}
    $scope.login = () ->
      $http.post('/login',
        email: $scope.user.email
        password: $scope.user.password
      ).success((response) ->
        $scope.loginError = 0
        if response isnt 'unauthorized'
          user.set response
          $rootScope.$emit 'loggedIn'
        else
          user.remove()
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
  'user',
  ($window, $scope, $rootScope, $http, $location, user) ->
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
            user.set response
            $rootScope.$emit 'loggedIn'
          else
            user.remove()
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
