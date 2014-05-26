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
      resolve:
        article: ['$rootScope', '$state', '$stateParams', 'Article', 'Message',
          ($rootScope, $state, $stateParams, Article, Message) ->
            $rootScope.loading = true
            Article.get(
              year: $stateParams.year
              volume: $stateParams.volume
              number: $stateParams.number
              section: $stateParams.section
              article: $stateParams.article
            ,
              (response) ->
                return
            ,
              (err) ->
                Message.add
                  success: false
                  persist: 1
                  expire: -1
                  msg: 'Article not found.'
                $state.go '404'
            ).$promise
        ]
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
  '$stateParams',
  'article',
  'Article',
  ($scope, $stateParams, article, Article) ->
    $scope.article = article
    $scope.error = []
    $scope.response = null
    $scope.updateArticle = () ->
      Article.update
        year: $stateParams.year
        volume: $stateParams.volume
        number: $stateParams.number
        section: $stateParams.section
        article: $stateParams.article
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

          if redirect
            if redirect is 'reload'
              $state.go($state.current, $stateParams,
                reload: true
                inherit: false
                notify: true
              )
            else if redirect is 'previous'
              $state.go $state.previous
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
