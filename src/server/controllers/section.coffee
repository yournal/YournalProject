exports.SectionCtrl = (IssueModel, SectionModel) ->

  getSection: (req, res) ->
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
      res.json section
    )

  getSections: (req, res) ->
    IssueModel.findOne(req.params, (err, document) ->
      if err
        return res.json 500, err: err
      if not document?
        return res.json 500, err: {msg: 'Issue does not exist.'}
      res.json document.sections
    )

  deleteSection: (req, res) ->
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
      section.remove()
      document.save (err) ->
        if err
          return res.status(400).send 'Unknown error occured.'
        res.json section
    )

  createSection: (req, res) ->
    req.checkBody('title', 'Title is required.').notEmpty()
    req.checkBody('abbreviation', 'Abbreviation is required.').notEmpty()
    req.checkBody('abbreviation', 'Abbreviation must be 2 characters length.').len(2, 2)
    req.checkBody('policyStatement', 'Policy statement is required.').notEmpty()

    req.checkParams('year', 'Wrong year format provided.').isInt()
    req.checkParams('volume', 'Wrong volume format provided.').isInt()
    req.checkParams('number', 'Wrong number format provided.').isInt()

    errors = req.validationErrors()
    if errors
      return res.status(400).json errors

    section = new SectionModel(
      title: req.body.title,
      abbreviation: req.body.abbreviation,
      policyStatement: req.body.policyStatement,
      articles: []
    )

    IssueModel.findOne(req.params, (err, document) ->
      if err
        return res.json 500, err: err
      if not document?
        return res.json 500, err: {msg: 'Issue does not exist.'}
      document.sections.push section
      document.save (err) ->
        if err
          return res.status(400).send 'Unknown error occured.'
        res.json section
    )

  updateSection: (req, res) ->
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

      section.title = req.body.title
      section.abbreviation = req.body.abbreviation
      section.policyStatement = req.body.policyStatement

      document.save (err) ->
        if err
          return res.status(400).send 'Unkown error occured.'

        res.json section
    )
