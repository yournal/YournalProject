module = mean.module 'yournal.admin.article'

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('article-new',
      url: '/admin/article/new'
      templateUrl: module.mean.resource('admin/article/admin-article-new.html')
      controller: module.mean.namespace('NewCtrl')
      data:
        access:
          allow: ['admin']
          state: 'login'
    )
    $stateProvider.state('article-edit',
      url: '/admin/article/edit/:year/:volume/:number/:section/:article'
      templateUrl: module.mean.resource('admin/article/admin-article-edit.html')
      controller: module.mean.namespace('EditCtrl')
      data:
        access:
          allow: ['admin']
          state: 'login'
    )
]

module.controller module.mean.namespace('NewCtrl'), [
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
      ,
        (err) ->
          $scope.response = null
          if typeof err.data isnt 'object'
            $scope.error = [msg: err.data]
          else
            $scope.error = err.data
]



module.controller module.mean.namespace('EditCtrl'), [
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

module.controller module.mean.namespace('DeleteCtrl'), [
  '$scope',
  '$rootScope',
  '$state',
  '$stateParams',
  'Article',
  'Message',
  ($scope, $rootScope, $state, $stateParams, Article, Message) ->
    $scope.delete = (year, volume, number, section, article, redirect) ->
      data =
        year: parseInt year
        volume: parseInt volume
        number: parseInt number
        section: section
        article: article


      Article.delete(
        data
      ,
        (response) ->
          Message.add
            success: true
            msg: 'Article "' + response.title + '" successfully deleted.'

          if not redirect
            $rootScope.$emit 'rebind'
          else
            $state.go redirect
      ,
        (err) ->
          if err.data?
            err = err.data
            if err.err?
              if err.err.msg?
                err = err.err.msg
              else
                err = 'Unkown error.'
          Message.add
            success: false
            msg: err
      )

]


