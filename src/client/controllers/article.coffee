controller = ($scope, $routeParams, Article) ->
  $scope.article = Article.get({articleId: $routeParams.articleId})


app = angular.module 'yournal.controllers'
app.controller 'ArticleController', [
  '$scope', '$routeParams', 'Article', controller
]

