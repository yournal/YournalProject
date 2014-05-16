controller = ($scope, $stateParams, $window, Article) ->
  $scope.article = Article.get({articleId: $stateParams.articleId})
  $scope.location = $window.location.href

app = angular.module 'yournal.controllers'
app.controller 'ArticleController', [
  '$scope', '$stateParams', '$window', 'Article', controller
]

