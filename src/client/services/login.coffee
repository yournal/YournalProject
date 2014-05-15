service = ($resource) ->
  

app = angular.module 'yournal.services'
app.factory 'Login', ['$resource', service]