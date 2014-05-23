app = mean.module 'yournal', [
  'ngResource',
  'ngAnimate',
  'ui.router',
  'ui.bootstrap',
  'ui.unique',
  'ngDisqus',
  'yournal.interceptors',
  'yournal.services',
  'djds4rce.angular-socialshare',
  'yournal.admin',
  'yournal.current',
  'yournal.search',
  'yournal.issue',
  'yournal.auth',
  'yournal.archives',
  'yournal.article',
  'yournal.visualization',
  'yournal.layout',
  'angulartics',
  'angulartics.google.analytics'
]

# Bootstrap
mean.ready = (app) ->
  if window.location.hash is '#_=_'
    window.location.hash = '#!'
mean.bootstrap = (app) ->
  injector = angular.injector(['ng'])
  $http = injector.get('$http')
  $http.get('/logged').then (response) ->
    app.constant 'user', response.data
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
  'user',
  'User',
  'Message',
  ($rootScope, $state, $stateParams, $mean, user, User, Message) ->
    $rootScope.$state = $state
    $rootScope.$stateParams = $stateParams
    $rootScope.$mean = $mean # register mean into global scope

    if user isnt 'unauthorized'
      User.set user
    else
      User.remove()

    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      if toState.data? and toState.data.access?
        access = toState.data.access
        if (access.deny? and User.authorize access.deny) or (access.allow? and not User.authorize access.allow)
          event.preventDefault()
          if access.state?
            $state.transitionTo access.state
          else
            $state.transitionTo 'home'

    $rootScope.previousState = {}
    $rootScope.currentState = {}
    $rootScope.$on '$stateChangeSuccess', (ev, to, toParams, from, fromParams) ->
      $rootScope.previousState =
        state: from.name
        params: fromParams
      $rootScope.currentState =
        state: to.name
        params: toParams
])
