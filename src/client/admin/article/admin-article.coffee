module = mean.module 'yournal.admin.article'

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('article-new',
      url: '/admin/article/new'
      templateUrl: module.mean.resource('admin/article/admin-article-new.html')
      controller: module.mean.namespace('ArticleNewCtrl')
      data:
        access:
          allow: ['admin']
          state: 'login'
    )
]

module.controller module.mean.namespace('ArticleNewCtrl'), [
  '$scope',
  'Issue',
  'Article',
  ($scope, Issue, Article) ->
    $scope.issues = Issue.query()
    $scope.year = null
    $scope.volume = null
    $scope.issue = null

    $scope.$watch 'year', (data)->
      $scope.volume = null
      $scope.issue = null
      $scope.section = null

    $scope.$watch 'volume', (data)->
      $scope.issue = null
      $scope.section = null

    $scope.createArticle = () ->

      if not $scope.issue?
        $scope.issue = {}

      article = new Article(
        title: $scope.title
        authors: $scope.authors
        keywords: $scope.keywords
        abstract: $scope.abstract
        content: $scope.content
      )

      article.$save
        year: $scope.year
        volume: $scope.volume
        number: $scope.issue.number
        section: $scope.section
      ,
        (response) ->
          $scope.articleForm.$setPristine()
          $scope.response = response
          $scope.error = []
          $scope.title = null
          $scope.authors = null
          $scope.keywords = null
          $scope.abstract = null
          $scope.content = null
          $scope.year = null
      ,
        (err) ->
          $scope.response = null
          if typeof err.data isnt 'object'
            $scope.error = [msg: err.data]
          else
            $scope.error = err.data
]
