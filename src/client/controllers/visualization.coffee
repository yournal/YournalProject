controller = ($scope) ->
  $scope.data = [
    {name: "Greg", score: 98},
    {name: "Ari", score: 96},
    {name: 'Q', score: 5},
    {name: "Loser", score: 48}
  ]

app = angular.module 'yournal.controllers'
app.controller 'VisualizationController', [
  '$scope', controller
]
