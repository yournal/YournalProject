module = angular.module 'yournal.search', [
  'yournal.services'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('search',
      url: '/search'
      templateUrl: 'public/yournal/js/search/search.html'
      controller: 'yournal.search.SearchCtrl'
    )
]

module.controller 'yournal.search.SearchCtrl', [
  '$scope',
  'Article',
  ($scope, Article) ->
    $scope.articles = Article.all()
    $scope.query = {}
    $scope.query.result = '!'
    $scope.search = (query) ->
      if !(query?) || query.length == 0
        query = '!'
      $scope.query.result = query
]
