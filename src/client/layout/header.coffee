module = mean.module 'yournal.layout.header'

module.controller module.mean.namespace('HeaderCtrl'), [
  '$scope',
  ($scope) ->
    $scope.collapsed = true
]
