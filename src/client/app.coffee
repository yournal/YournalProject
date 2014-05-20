app = mean.module 'yournal', [
  'ngResource',
  'ngAnimate',
  'ui.router',
  'ui.bootstrap',
  'ui.unique',
  'ngDisqus',
  'yournal.interceptors',
  'yournal.services',
  'yournal.admin',
  'yournal.current',
  'yournal.search',
  'yournal.issue',
  'yournal.auth',
  'yournal.archives',
  'yournal.article',
  'yournal.visualization',
  'yournal.layout',
]

# Bootstrap
mean.ready = (app) ->
  if window.location.hash is '#_=_'
    window.location.hash = '#!'
mean.bootstrap = (app) ->
  injector = angular.injector(['ng'])
  $http = injector.get('$http')
  $http.get('/logged').then (response) ->
    app.constant 'userData', response.data
    angular.bootstrap document, [app.name]
mean.init app

# Config
app.config([
  '$urlRouterProvider',
  '$locationProvider',
  '$disqusProvider',
  ($urlRouterProvider, $locationProvider, $disqusProvider) ->
    $locationProvider.html5Mode true
    $locationProvider.hashPrefix '!'
    $disqusProvider.setShortname 'Yournal'
    $urlRouterProvider.otherwise('/')
])

# Run
app.run([
  '$rootScope',
  '$state',
  '$stateParams',
  '$mean',
  'userData',
  'user'
  ($rootScope, $state, $stateParams, $mean, userData, user) ->
    $rootScope.$state = $state
    $rootScope.$stateParams = $stateParams
    $rootScope.$mean = $mean # register mean into global scope

    if userData isnt 'unauthorized'
      user.set userData
    else
      user.remove()

    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      if toState.data?
        if (toState.data.deny? and user.authorize toState.data.deny) or (toState.data.allow? and not user.authorize toState.data.allow)
          event.preventDefault()
          $state.transitionTo 'home'

])
