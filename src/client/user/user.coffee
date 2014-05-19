module = mean.module 'yournal.user'

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('login',
      url: '/login'
      templateUrl: module.mean.resource('user/user-login.html')
    )
    $stateProvider.state('register',
      url: '/register'
      templateUrl: module.mean.resource('user/user-register.html')
    )
]
