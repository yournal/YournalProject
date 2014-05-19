controller = ($scope, Article) ->

  articlesPromise = Article.query()
  nodesList = []
  linksList = []
  authors = {}

  articlesPromise.$promise.then((articles) ->
    for article in articles
      articleNode = { "name": article.title, "group": 1, "id": article.id }
      target = nodesList.push(articleNode) - 1

      for author in article.authors
        if authors[author]?
          source = authors[author]
        else
          authorNode = { "name": author, "group": 2 }
          source = nodesList.push(authorNode) - 1
        linkNode = {"source": source,"target": target, "value": 1}
        linksList.push linkNode

    $scope.data = {
      nodes: nodesList
      links: linksList
    }
  )

app = angular.module 'yournal.controllers'
app.controller 'VisualizationController', [
  '$scope', 'Article', controller
]
