module = meanstack.module 'yournal.visualisation', [
  'yournal.directives.fisheye'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('visualisation',
      url: '/visualisation'
      templateUrl: module.mean.resource('visualisation/visualisation.html')
      controller: module.mean.module('VisualisationCtrl')
    )
]

module.controller module.mean.module('VisualisationCtrl'), [
  '$scope',
  'Article',
  ($scope, Article) ->
    articlesPromise = Article.getArticles()
    nodesList = []
    linksList = []
    authors = {}
    articlesPromise.$promise.then((articles) ->
      for article in articles
        articleNode =
          'name': article.title
          'group': 1
        target = nodesList.push(articleNode) - 1
        for author in article.authors
          console.log author
          if authors[author]?
            source = authors[author]
            console.log 'in'
          else
            authorNode =
              'name': author
              'group': 2
            source = nodesList.push(authorNode) - 1
            console.log 'out'
          linkNode =
            'source': source
            'target': target
            'value': 1
          linksList.push linkNode
      $scope.data =
        nodes: nodesList
        links: linksList
    )
]
