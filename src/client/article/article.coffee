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
    )
]

module.controller module.mean.namespace('ArticleCtrl'), [
  '$rootScope',
  '$scope',
  '$state',
  '$stateParams',
  'Article',
  'User',
  'Message'
  '$FB',
  ($rootScope, $scope, $state, $stateParams, Article, User, Message, $FB) ->
    $scope.year = parseInt $stateParams.year
    $scope.volume = parseInt $stateParams.volume
    $scope.number = parseInt $stateParams.number
    $scope.section = $stateParams.section

    $scope.article = Article.get(
      year: $stateParams.year
      volume: $stateParams.volume
      number: $stateParams.number
      section: $stateParams.section
      article: $stateParams.article
    , (response) ->
      $FB.init('565410586907554')
      $scope.shareUrl = window.location.href
      $scope.user = User
      return
    ,
      (err) ->
        $state.go('404')
    )
]
