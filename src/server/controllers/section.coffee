module.exports = ($views, IssueModel, SectionModel) ->
  getSection: (req, res) ->
    IssueModel.findOne({
      year: req.params.year,
      volume: req.params.volume,
      number: req.params.number
    }, (err, document) ->
      if err
        return res.json
          err: err
          500
      section = document.sections.id(req.params.section)
      if not section?
        return res.send
          err: {msg: 'Section does not exist.'}
          500
      res.send section
    )

  getSections: (req, res) ->
    IssueModel.findOne(req.params, (err, document) ->
      if err
        return res.json
          err: err
          500
      res.send document.sections
    )

  deleteSection: (req, res) ->
    IssueModel.findOne({
      year: req.params.year,
      volume: req.params.volume,
      number: req.params.number
    }, (err, document) ->
      if err
        return res.json
          err: err
          500

      section = document.sections.id(req.params.section)

      if not section?
        return res.send
          err: {msg: 'Section does not exist.'}
          500

      section.remove()

      document.save (err) ->
        if err
          return res.status(400).send('Unknown error occured.')
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
      return res.status(400).send errors

    section = new SectionModel(
      title: req.body.title,
      abbreviation: req.body.abbreviation,
      policyStatement: req.body.policyStatement,
      articles: []
    )

    IssueModel.findOne(req.params, (err, document) ->
      if err
        return res.json
          err: err
          500
      document.sections.push section
      document.save (err) ->
        if err
          return res.status(400).send('Please fill all the required fields.')
        res.send section
    )
