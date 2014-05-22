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
    $stateProvider.state('article-edit',
      url: '/admin/article/edit/:year/:volume/:number/:section/:article'
      templateUrl: module.mean.resource('admin/article/admin-article-edit.html')
      controller: module.mean.namespace('ArticleEditCtrl')
      data:
        access:
          allow: ['admin']
          state: 'login'
    )
    $stateProvider.state('article-delete',
      url: '/issues/:year/:volume/:number/sections/:section/articles/:article'
      templateUrl: module.mean.resource('article/article.html')
      controller: module.mean.namespace('ArticleDeleteCtrl')
      data:
        access:
          allow: ['admin']
          state: 'login'
    )
]

module.controller module.mean.namespace('ArticleEditCtrl'), [
  '$scope',
  '$state',
  '$stateParams',
  'Article'
  ($scope, $state, $stateParams, Article) ->
    year = parseInt($stateParams.year)
    volume = parseInt($stateParams.volume)
    number = parseInt($stateParams.number)
    sectionId = $stateParams.section
    articleId = $stateParams.article

    article = Article.get(
      year: year
      volume: volume
      number: number
      section: sectionId
      article: articleId
    ,
      (response) ->
        return
    ,
      (err) ->
        $state.go '404'
    )

    $scope.article = article
    $scope.error = []
    $scope.response = null
    $scope.updateArticle = () ->
      Article.update
        year: year
        volume: volume
        number: number
        section: sectionId
        article: articleId
      ,
        article
      ,
        (response) ->
          $scope.response = response
          $scope.error = []
      ,
        (err) ->
          $scope.response = null
          if typeof err.data isnt 'object'
            $scope.error = [msg: err.data]
          else
            $scope.error = err.data

]

module.controller module.mean.namespace('ArticleDeleteCtrl'), [
  '$scope',
  '$state',
  '$stateParams',
  'Article'
  ($scope, $state, $stateParams, Article) ->
    year = parseInt($stateParams.year)
    volume = parseInt($stateParams.volume)
    number = parseInt($stateParams.number)
    sectionId = $stateParams.section
    articleId = $stateParams.article

    article = Article.get(
      year: year
      volume: volume
      number: number
      section: sectionId
      article: articleId
    ,
      (response) ->
        return
    ,
      (err) ->
        $state.go '404'
    )

    $scope.article = article
    $scope.error = []
    $scope.response = null
    $scope.deleteArticle = () ->
      Article.delete(
        year: $stateParams.year
        volume: $stateParams.volume
        number: $stateParams.number
        section: $stateParams.section
        article: $stateParams.article
      , (response) ->
        Error.add {
          success: true
          msg: 'Article "' + response.title + '" successfully deleted.'
        }
        $state.go('home')
      ,
        (err) ->
          Error.add {
            success: false
            msg: err.msg
          }
          $state.go('home')
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
