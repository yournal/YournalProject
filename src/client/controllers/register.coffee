controller = ($scope, Login) ->
  

app = angular.module 'yournal.controllers'
app.controller 'RegisterController', [
  '$scope', 'Register', controller
]