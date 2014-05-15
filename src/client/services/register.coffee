service = ($resource) ->
  

app = angular.module 'yournal.services'
app.factory 'Register', ['$resource', service]