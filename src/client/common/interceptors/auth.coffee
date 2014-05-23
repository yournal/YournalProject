module = mean.module 'yournal.interceptors'

module.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push 'authInterceptor'
]

module.factory 'authInterceptor', [
  '$q',
  '$window',
  '$location',
  ($q, $window, $location) ->
    response: (response) ->
      if response.status is 401
        $location.path '/login'
        $q.reject response
      return response or $q.when response
    responseError: (response) ->
      if response.status is 401
        $location.path '/login'
        $q.reject response
      else if response.status is 403
        $window.location = '/logout'
        return
      return $q.reject response
]
