module = angular.module 'yournal.visualization', [
  'yournal.directives.fisheye'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('visualization',
      url: '/visualization'
      templateUrl: 'public/yournal/js/visualization/visualization.html'
      controller: 'yournal.visualization.VisualisationCtrl'
      resolve:
        articles: ['$rootScope', 'Article', ($rootScope, Article) ->
          $rootScope.loading = true
          Article.all().$promise
        ]
    )
]

module.controller 'yournal.visualization.VisualisationCtrl', [
  '$scope',
  'articles',
  ($scope, articles) ->
    nodesList = []
    linksList = []
    authors = {}
    for article in articles
      articleNode =
        'name': article.title
        'year': article.year
        'volume': article.volume
        'issue': article.issue
        'section': article.section
        'group': 1
        '_id': article._id
      target = nodesList.push(articleNode) - 1
      for author in article.authors
        if authors[author]?
          source = authors[author]
        else
          authorNode =
            'name': author
            'group': 2
          source = nodesList.push(authorNode) - 1
          authors[author] = source
        linkNode =
          'source': source
          'target': target,
          'value': 1
        linksList.push linkNode
    $scope.data =
      nodes: nodesList
      links: linksList
]
