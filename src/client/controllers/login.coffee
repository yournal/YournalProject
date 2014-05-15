controller = ($scope, Login) ->
  

app = angular.module 'yournal.controllers'
app.controller 'LoginController', [
  '$scope', 'Login', controller
]