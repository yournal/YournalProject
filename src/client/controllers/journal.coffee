controller = ($scope, $routeParams, Journal) ->
  $scope.journal = Journal.get({journal_id: $routeParams.journal_id})
  
app = angular.module 'yournal.controllers'
app.controller 'JournalController', [
  '$scope', '$routeParams', 'Journal', controller
]