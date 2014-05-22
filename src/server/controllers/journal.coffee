exports.controller = {}

exports.controller.JournalCtrl = (JournalModel) ->

  getJournal: (req, res) ->
    JournalModel.findOne (err, doc) ->
      if not doc?
        doc = new JournalModel()
        doc.save()
      res.json doc

  updateJournal: (req, res) ->
    req.checkBody('title', 'Title is required.').notEmpty()
    req.checkBody('description', 'Description is required.').notEmpty()
    
    JournalModel.findOne (err, doc) ->
      doc.title = req.body.title
      doc.description = req.body.description
      doc.save (err) ->
        if err
          return res.status(400).send 'Unkown error occured.'
        res.json doc
