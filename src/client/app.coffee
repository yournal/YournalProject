# Bootstrap
angular.element(document).ready ->
  if window.location.hash == '#_=_'
    window.location.hash = '#!'
  angular.bootstrap document, ['yournal']

# Dynamically add angular modules declared by packages
modules = []
for index of window.modules
  dependencies = []
  if window.modules[index].angularDependencies?
    dependencies = window.modules[index].angularDependencies
  angular.module window.modules[index].module, dependencies
  modules.push window.modules[index]

# Register modules
app = angular.module('yournal', modules.concat([
  'ngRoute',
  'ngResource',
  'yournal.filters',
  'yournal.services',
  'yournal.directives',
  'yournal.controllers',
  'ui.bootstrap',
  'ui.router'
]))

# Register modules
angular.module 'yournal.filters', []
angular.module 'yournal.controllers', []
angular.module 'yournal.services', []

app.config(['$stateProvider', '$urlRouterProvider',
  ($stateProvider, $urlRouterProvider) ->
    $stateProvider.state('home',
      url: '/'
      templateUrl: 'views/index.html'
      controller: 'IndexController'
    )
    $stateProvider.state('search',
      url: '/search'
      templateUrl: 'views/search.html'
      controller: 'SearchController'
    )
    $urlRouterProvider.otherwise('/')
])
app.config(['$locationProvider', ($locationProvider) ->
  $locationProvider.hashPrefix '!'
])

app.run ($rootScope, $state, $stateParams) ->
  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams