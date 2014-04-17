controller = ($scope, Issues) ->
  $scope.issues = Issues.query()

app = angular.module 'yournal.controllers'
app.controller 'ArchiveController', [
  '$scope', 'Issues', controller
]