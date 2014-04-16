version = (version) ->
  return (scope, elm, attrs) ->
    lm.text version

app = angular.module 'yournal.directives', []
app.directive 'appVersion', ['version', version]