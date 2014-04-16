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
  'yournal.controllers'
]))

angular.module 'yournal.services', []
angular.module 'yournal.controllers', []

app.config(['$locationProvider', ($locationProvider) ->
  $locationProvider.hashPrefix '!'
])

app.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/view1',
    templateUrl: 'views/partial1.html',
    controller: 'ExampleController'
  )
  $routeProvider.when('/journals',
    templateUrl: 'views/journals.html',
    controller: 'ExampleController'
  )
  $routeProvider.when('/journals/:journal_id',
    templateUrl: 'views/journal.html',
    controller: 'JournalController'
  )
  $routeProvider.otherwise({redirectTo: '/view1'})
])
