module = mean.module 'yournal.search', [
  'yournal.services'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('search',
      url: '/search'
      templateUrl: module.mean.resource('search/search.html')
      controller: module.mean.namespace('SearchCtrl')
    )
]

module.controller module.mean.namespace('SearchCtrl'), [
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
