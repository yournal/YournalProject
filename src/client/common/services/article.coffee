module = meanstack.module 'yournal.services'

module.factory 'Article', [
  '$resource',
  ($resource) ->
    getArticles: () ->
      data = $resource(
        module.mean.asset("other/json/articles.json"), {},
          query:
            method: 'GET'
            isArray: true
      )
      data.query()
    getArticle: (id) ->
      data = $resource(
        module.mean.asset("other/json/articles/#{id}.json"), {},
          query:
            method: 'GET'
      )
      data.get()
]
