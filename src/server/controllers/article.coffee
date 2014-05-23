exports.controller = {}

exports.controller.ArticleCtrl = (IssueModel, ArticleModel) ->

  getArticle: (req, res) ->
    IssueModel.findOne({
      year: req.params.year,
      volume: req.params.volume,
      number: req.params.number
    }, (err, document) ->
      if err
        return res.json 500, err: err
      if not document?
        return res.json 500, err: {msg: 'Issue does not exist.'}
      section = document.sections.id(req.params.section)
      if not section?
        return res.json 500, err: {msg: 'Section does not exist.'}
      article = section.articles.id(req.params.article)
      if not article?
        return res.json 500, err: {msg: 'Article does not exist.'}
      res.json article
    )

  getArticles: (req, res) ->
    IssueModel.findOne({
      year: req.params.year,
      volume: req.params.volume,
      number: req.params.number
    }, (err, document) ->
      if err
        return res.json 500, err: err
      if not document?
        return res.json 500, err: {msg: 'Issue does not exist.'}
      section = document.sections.id(req.params.section)
      if not section?
        return res.json 500, err: {msg: 'Section does not exist.'}
      res.json section.articles
    )

  getAllArticles: (req, res) ->
    IssueModel.find({}, (err, document) ->
      if err
        return res.json 500, err: err
      if not document?
        return res.json 500, err: {msg: 'Issue does not exist.'}
      articles = []
      for issue in document
        for section in issue.sections
          for article in section.articles
            a = {} # we need a copy of object
            a._id = article._id
            a.content = article.content
            a.abstract = article.abstract
            a.title = article.title
            a.keywords = article.keywords
            a.authors = article.authors
            a.year = issue.year
            a.volume = issue.volume
            a.issue = issue.number
            a.section = section._id
            articles.push a
      res.json articles
    )

  createArticle: (req, res) ->
    req.checkBody('title', 'Title is required.').notEmpty()
    req.checkBody('authors', 'Authors are required.').notEmpty()
    req.checkBody('abstract', 'Abstract is required.').notEmpty()
    req.checkBody('content', 'Content is required.').notEmpty()

    req.checkParams('year', 'Wrong year format provided.').isInt()
    req.checkParams('volume', 'Wrong volume format provided.').isInt()
    req.checkParams('number', 'Wrong number format provided.').isInt()
    req.checkParams('section', 'Section ID is required.').notEmpty()

    errors = req.validationErrors()
    if errors
      return res.status(400).json errors

    authors = req.body.authors.split(',')
    for k, v of authors
      v = v.trim()
      v = v.split(' ')
      for x, y of v
        v[x] = y[0].toUpperCase() + y.slice(1)
      v = v.join(' ')
      authors[k] = v[0].toUpperCase() + v.slice(1)

    keywords = []
    if req.body.keywords?
      keywords = req.body.keywords.split(',')
      for k, v of keywords
        v = v.trim()
        v = v.split(' ')
        for x, y of v
          v[x] = y[0].toUpperCase() + y.slice(1)
        v = v.join(' ')
        keywords[k] = v[0].toUpperCase() + v.slice(1)

    article = new ArticleModel(
      title: req.body.title,
      authors: authors,
      keywords: keywords,
      abstract: req.body.abstract,
      content: req.body.content
    )

    IssueModel.findOne({
      year: req.params.year,
      volume: req.params.volume,
      number: req.params.number
    }, (err, document) ->
      if err
        return res.json
          err: err
          500
      if not document?
        return res.json 500, err: {msg: 'Issue does not exist.'}
      section = document.sections.id(req.params.section)
      if not section?
        return res.json 500, err: {msg: 'Section does not exist.'}
      section.articles.push article
      document.save (err) ->
        if err
          return res.status(400).send 'Unkown error occured.'
        res.json article
    )

  deleteArticle: (req, res) ->
    IssueModel.findOne({
      year: req.params.year
      volume: req.params.volume
      number: req.params.number
    }, (err, document) ->
      if err
        return res.json 500, err: err
      if not document?
        return res.json 500, err: {msg: 'Issue does not exist.'}
      section = document.sections.id(req.params.section)
      if not section?
        return res.json 500, err: {msg: 'Section does not exist.'}
      article = section.articles.id(req.params.article)
      if not article?
        return res.json 500, err: {msg: 'Article does not exist.'}
      article.remove()
      document.save (err) ->
        if err
          return res.status(400).send 'Unkown error occured.'
      res.json article
    )

  updateArticle: (req, res) ->
    IssueModel.findOne({
      year: req.params.year
      volume: req.params.volume
      number: req.params.number
    }, (err, document) ->
      if err
        return res.json 500, err: err
      if not document?
        return res.json 500, err: {msg: 'Issue does not exist.'}
      section = document.sections.id(req.params.section)
      if not section?
        return res.json 500, err: {msg: 'Section does not exist.'}
      article = section.articles.id(req.params.article)
      if not article?
        return res.json 500, err: {msg: 'Article does not exist.'}
      article.title = req.body.title
      article.authors = req.body.authors
      article.keywords = req.body.keywords
      article.abstract = req.body.abstract
      article.content = req.body.content

      document.save (err) ->
        if err
          return res.status(400).send 'Unkown error occured.'

        res.json article
    )
