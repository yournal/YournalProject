controller = ($scope, $stateParams, Article) ->
  $scope.article = Article.get({articleId: $stateParams.articleId})

app = angular.module 'yournal.controllers'
app.controller 'ArticleController', [
  '$scope', '$stateParams', 'Article', controller
]

