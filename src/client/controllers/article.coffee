controller = ($scope, $stateParams, $window, Article, Issues, Section) ->
  $scope.issues = Issues.query()
  $scope.sections = Section.query()
  $scope.article = Article.get({articleId: $stateParams.articleId})
  $scope.location = $window.location.href
  $scope.shareUrl = window.location.href

app = angular.module 'yournal.controllers'
app.controller 'ArticleController', [
  '$scope', '$stateParams', '$window', 'Article', 'Issues', 'Section', controller
]