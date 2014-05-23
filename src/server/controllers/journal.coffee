exports.controller = {}

exports.controller.JournalCtrl = (JournalModel) ->

  getJournal: (req, res) ->
    JournalModel.findOne (err, document) ->
      if not document?
        document = new JournalModel()
        document.save()
      res.json document

  updateJournal: (req, res) ->
    req.checkBody('title', 'Title is required.').notEmpty()
    req.checkBody('description', 'Description is required.').notEmpty()

    errors = req.validationErrors()
    if errors
      return res.status(400).json errors

    JournalModel.findOne (err, document) ->
      if err
        return res.json 500, err: err
      if not document?
        return res.json 500, err: {msg: 'Journal does not exist.'}
      document.title = req.body.title
      document.description = req.body.description
      document.save (err) ->
        if err
          return res.status(400).send 'Unkown error occured.'
        res.json document
