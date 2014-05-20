module.exports = ($views, ArticleModel) ->

  getArticles: (req, res) ->
    ArticleModel.find({}, (err, json) ->
      if err
        return res.json
          err: err
          500
      res.send json
    )

  getArticle: (req, res) ->
    ArticleModel.find(req.params.id, (err, json) ->
      if err
        return res.json
          err: err
          500
      res.send json
    )

  createArticle: (req, res) ->
    article = new ArticleModel(
      title: req.params.t,
      authors: req.params.a,
      keywords: req.params.k,
      abstract: req.params.abstract,
      content: req.params.content
    )
    article.save (err) ->
      if err
        return res.json
          err: err
          500
      res.send 'Article created.'
