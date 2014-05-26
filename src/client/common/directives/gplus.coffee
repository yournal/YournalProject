module = angular.module 'yournal.gplus', []

module.directive('googlePlus', [() ->
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
