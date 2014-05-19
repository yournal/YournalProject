module = mean.module 'yournal.visualization', [
  'yournal.directives.fisheye'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('visualization',
      url: '/visualization'
      templateUrl: module.mean.resource('visualization/visualization.html')
      controller: module.mean.namespace('VisualisationCtrl')
    )
]

module.controller module.mean.namespace('VisualisationCtrl'), [
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
          'id': article.id
        target = nodesList.push(articleNode) - 1
        for author in article.authors
          if authors[author]?
            source = authors[author]
          else
            authorNode =
              'name': author
              'group': 2
            source = nodesList.push(authorNode) - 1
          linkNode =
            'source': source
            'target': target,
            'value': 1
          linksList.push linkNode
      $scope.data =
        nodes: nodesList
        links: linksList
    )
]
