app = angular.module('yournal', [
  'ngRoute',
  'yournal.filters',
  'yournal.services.journal',
  'yournal.services.article',
  'yournal.directives',
  'yournal.controllers'
])

app.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/view1',
    templateUrl: 'views/partial1.html',
    controller: 'ExampleController'
  )
  $routeProvider.otherwise({redirectTo: '/view1'})
])