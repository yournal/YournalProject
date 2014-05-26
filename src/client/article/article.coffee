module = mean.module 'yournal.article', [
  'yournal.services',
  'yournal.admin.article'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('article',
      url: '/issue/:year/:volume/:number/sections/:section/article/:article'
      templateUrl: module.mean.resource('article/article.html')
      controller: module.mean.namespace('ArticleCtrl')
      resolve:
        article: ['$rootScope', '$stateParams', '$state', 'Article',
          ($rootScope, $stateParams, $state, Article) ->
            $rootScope.loading = true
            Article.get(
              year: $stateParams.year
              volume: $stateParams.volume
              number: $stateParams.number
              section: $stateParams.section
              article: $stateParams.article
            , (response) ->
              return
            ,
              (err) ->
                $state.go('404')
            ).$promise
        ]
    )
]

module.controller module.mean.namespace('ArticleCtrl'), [
  '$window',
  '$scope',
  '$stateParams',
  'article',
  'User',
  '$FB',
  ($window, $scope, $stateParams, article, User, $FB) ->
    $scope.year = parseInt $stateParams.year
    $scope.volume = parseInt $stateParams.volume
    $scope.number = parseInt $stateParams.number
    $scope.section = $stateParams.section
    $scope.article = article
    $FB.init('328179763996125')
    $scope.url = $window.location.href
    $scope.user = User
]
