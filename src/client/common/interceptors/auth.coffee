module = mean.module 'yournal.interceptors'

module.config ['$httpProvider', ($httpProvider) ->
  $httpProvider.interceptors.push 'authInterceptor'
]

module.factory 'authInterceptor', [
  '$q',
  '$location',
  ($q, $location) ->
    response: (response) ->
      if response.status is 401
        $location.path '/login'
        $q.reject response
      return response or $q.when response
    responseError: (response) ->
      if response.status is 401
        $location.path '/login'
        $q.reject response
      return $q.reject response
]
