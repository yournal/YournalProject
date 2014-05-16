analytics = ([ "$rootScope", "$location", ($rootScope, $location) ->
  link: (scope, elem, attrs, ctrl) ->
    $rootScope.$on "$routeChangeSuccess", (event, currRoute, prevRoute) ->
      ga "set", "page", $location.path()
      ga "send", "pageview"
])

app = angular.module 'yournal.directives'
app.directive 'yournalAnalytics', analytics