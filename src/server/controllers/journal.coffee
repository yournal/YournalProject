exports.controller = {}

exports.controller.JournalCtrl = (JournalModel) ->

  getJournals: (req, res) ->
    JournalModel.find({}, (err, json) ->
      if err
        return res.json 500, err: err
      res.json json
    )

  getJournal: (req, res) ->
    JournalModel.find(req.params.id, (err, json) ->
      if err
        return res.json 500, err: err
      res.json json
    )

  createJournal: (req, res) ->
    journal = new JournalModel(
      title: req.params.t,
      description: req.params.d
    )
    journal.save (err) ->
      if err
        return res.json 500, err: err
      res.send 'Journal created.'
