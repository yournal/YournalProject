controller = ($scope, Journal, Article, Section) ->
  $scope.journals = Journal.query()
   
app = angular.module 'yournal.controllers'
app.controller 'IndexController', [
  '$scope', 'Journal', 'Article', 'Section', controller
]