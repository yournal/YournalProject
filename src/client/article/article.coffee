module = mean.module 'yournal.article', [
  'yournal.services'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('article',
      url: '/article/:articleId'
      templateUrl: module.mean.resource('article/article.html')
      controller: module.mean.namespace('ArticleCtrl')
    )
]

module.controller module.mean.namespace('ArticleCtrl'), [
  '$scope',
  '$stateParams',
  'Issue',
  'Article',
  'Section',
  'User',
  '$FB',
  ($scope, $stateParams, Issue, Article, Section, User, $FB) ->
    $scope.article = Article.getArticle($stateParams.articleId)
    $scope.issues = Issue.getIssues()
    $scope.sections = Section.getSections()
    $FB.init('565410586907554')
    $scope.shareUrl = window.location.href
    $scope.user = User
]
