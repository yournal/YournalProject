module.exports = ($views, JournalModel) ->

  getJournals: (req, res) ->
    JournalModel.find({}, (err, json) ->
      if err
        return res.json
          err: err
          500
      res.send json
    )

  getJournal: (req, res) ->
    JournalModel.find(req.params.id, (err, json) ->
      if err
        return res.json
          err: err
          500
      res.send json
    )

  createJournal: (req, res) ->
    journal = new JournalModel(
      title: req.params.t,
      description: req.params.d
    )
    journal.save (err) ->
      if err
        return res.json
          err: err
          500
      res.send 'Journal created.'