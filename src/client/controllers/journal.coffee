controllerJournal = ($scope, $location, $stateParams, Journal) ->
  if !$stateParams.journal_id? || $stateParams.journal_id == ''
    $location.path '/'
  else
    $scope.journal = Journal.get({journal_id: $stateParams.journal_id})
  
app = angular.module 'yournal.controllers'
app.controller 'JournalController', [
  '$scope', '$location', '$stateParams', 'Journal', controllerJournal
]