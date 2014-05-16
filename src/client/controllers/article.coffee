controller = ($scope, $stateParams, Article) ->
  $scope.article = Article.get({articleId: $stateParams.articleId})
  $scope.shareUrl = window.location.href

app = angular.module 'yournal.controllers'
app.controller 'ArticleController', [
  '$scope', '$stateParams', 'Article', controller
]

