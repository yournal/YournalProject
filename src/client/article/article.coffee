module = meanstack.module 'yournal.article', [
  'yournal.services'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('article',
      url: '/article/:articleId'
      templateUrl: module.mean.resource('article/article.html')
      controller: module.mean.module('ArticleCtrl')
    )
]

module.controller module.mean.module('ArticleCtrl'), [
  '$scope',
  '$stateParams',
  'Issue',
  'Article',
  'Section',
  ($scope, $stateParams, Issue, Article, Section) ->
    $scope.article = Article.getArticle($stateParams.articleId)
    $scope.issues = Issue.getIssues()
    $scope.sections = Section.getSections()
]
