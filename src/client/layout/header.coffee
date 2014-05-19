module = meanstack.module 'yournal.layout.header'

module.controller module.mean.module('HeaderCtrl'), [
  '$scope',
  ($scope) ->
    $scope.collapsed = true
]
