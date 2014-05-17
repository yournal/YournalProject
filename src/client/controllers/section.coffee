controller = ($scope, Section, Issues) ->
  $scope.sections = Section.query()
  $scope.issues = Issues.query()

app = angular.module 'yournal.controllers'
app.controller 'SectionController', [
  '$scope', 'Section', 'Issues', controller
]