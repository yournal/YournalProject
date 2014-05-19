module.exports = ($views, SectionModel) ->

  getSections: (req, res) ->
    SectionModel.find({}, (err, json) ->
      if err
        return res.json
          err: err
          500
      res.send json
    )

  getSection: (req, res) ->
    SectionModel.find(req.params.id, (err, json) ->
      if err
        return res.json
          err: err
          500
      res.send json
    )

  createSection: (req, res) ->
    section = new SectionModel(
      title: req.params.t,
      abbreviation: req.params.a,
      policyStatement: req.params.p,
      articles: []
    )
    section.save (err) ->
      if err
        return res.json
          err: err
          500
      res.send 'Section created.'