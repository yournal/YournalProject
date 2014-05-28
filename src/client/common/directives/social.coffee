module = angular.module 'yournal.social', []

module.directive('yournalGooglePlus', [() ->
  link: (scope, element, attr) ->
    (() ->
      po = document.createElement('script')
      po.type = 'text/javascript'
      po.async = true
      po.src = 'https://apis.google.com/js/plusone.js'
      s = document.getElementsByTagName('script')[0]
      s.parentNode.insertBefore(po, s)
    )()
])

module.directive('yournalFacebook', [
  '$timeout',
  '$http',
  ($timeout, $http) ->
    scope: shares: '='
    transclude: true
    template: '<div ng-transclude></div>'
    link: (scope, element, attr) ->
      if attr.shares
        $http.get("http://graph.facebook.com/?id=#{attr.url}").success((res) ->
          if res.shares?
            scope.shares = res.shares
          else
            scope.shares = 0
        ).error(() ->
          scope.shares = 0
        )
      $timeout(() ->
        element.bind('click', () ->
          FB.ui(
            method: 'feed'
            name: attr.name
            link: attr.url
            picture: attr.pictureUrl
            caption: attr.caption
          )
        )
      )
])
