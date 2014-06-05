app = angular.module 'yournal', [
  'ngResource',
  'ngAnimate',
  'ui.router',
  'ui.bootstrap',
  'ui.unique',
  'ngDisqus',
  'yournal.interceptors',
  'yournal.services',
  'djds4rce.angular-socialshare',
  'yournal.social',
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

angular.module 'yournal.interceptors', []
angular.module 'yournal.services', []

# Bootstrap
angular.element(document).ready ->
  if window.location.hash is '#_=_'
    window.location.hash = '#!'
  injector = angular.injector(['ng'])
  $http = injector.get '$http'
  $http.get('/data.json').then (response) ->
    app.constant 'assets', response.assets
    $http.get('/auth').then (response) ->
      app.constant 'user', response.data
      angular.bootstrap document, ['yournal']

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

# Disable auto scroll
app.value '$anchorScroll', angular.noop

# Run
app.run([
  '$window',
  '$rootScope',
  '$state',
  '$stateParams',
  'assets',
  'user',
  'User',
  'Message',
  ($window, $rootScope, $state, $stateParams, assets, user, User, Message) ->
    $rootScope.$state = $state
    $rootScope.$stateParams = $stateParams
    $rootScope.assets = assets

    # Set current user
    if user isnt 'unauthorized'
      User.set user
    else
      User.remove()

    # Prevent access to unauthorized users
    $state.previous = $state.current
    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      $window.scrollTo 0, 0
      if toState.data? and toState.data.access?
        access = toState.data.access
        if (access.deny? and User.authorize access.deny) or (access.allow? and not User.authorize access.allow)
          event.preventDefault()
          if access.state?
            $state.transitionTo access.state
          else
            $state.transitionTo 'home'
    $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
      $state.previous = fromState
      $rootScope.loading = false
])
