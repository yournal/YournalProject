app = meanstack.module 'yournal', [
  'ngResource',
  'ngAnimate',
  'ui.router',
  'ui.bootstrap',
  'ui.unique',
  'ngDisqus',
  'yournal.admin',
  'yournal.current',
  'yournal.search',
  'yournal.issue',
  'yournal.user',
  'yournal.archives',
  'yournal.article',
  'yournal.visualisation',
  'yournal.layout',
]

# Bootstrap
meanstack.ready = (app) ->
  if window.location.hash is '#_=_'
    window.location.hash = '#!'
meanstack.bootstrap = (app) ->
  angular.bootstrap document, [app.name]
meanstack.init app

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
app.run(['$rootScope', '$state', '$stateParams', '$mean'
  ($rootScope, $state, $stateParams, $mean) ->
    $rootScope.$state = $state
    $rootScope.$stateParams = $stateParams
    $rootScope.$mean = $mean # register mean into global scope
])
