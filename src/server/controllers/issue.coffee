exports.IssueCtrl = (IssueModel) ->

  getIssue: (req, res) ->
    IssueModel.findOne(req.params, (err, document) ->
      if err
        return res.json 500, err: err
      if document?
        res.json document
      else
        res.json 404, err: 'Issue does not exist.'
    )

  getIssues: (req, res) ->
    params = {}
    if req.params.year?
      params['year'] = req.params.year
    if req.params.volume?
      params['volume'] = req.params.volume

    # Filter output
    fields = {}
    if req.query.filter?
      if typeof req.query.filter is 'object'
        for field in req.query.filter
          fields[field] = 0
      else
        fields[req.query.filter] = 0

    query = {}
    if req.query.sort?
      query['sort'] = {}
      if req.query.order?
        order = req.query.order
      else
        order = -1
      if typeof req.query.sort is 'object'
        for s in req.query.sort
          query['sort'][s] = order
      else
        query['sort'][req.query.sort] = order
    if req.query.limit?
      query['limit'] = req.query.limit

    IssueModel.find(params, fields, query, (err, document) ->
      if err
        return res.json 500, err: err
      if not document?
        return res.json 500, err: {msg: 'Issue does not exist.'}
      res.json document
    )

  deleteIssue: (req, res) ->
    IssueModel.findOne(req.params, (err, document) ->
      if err
        return res.json 500, err: err
      if not document?
        return res.json 500, err: {msg: 'Issue does not exist.'}
      document.remove()
      res.json document
    )

  createIssue: (req, res) ->
    issue = new IssueModel(
      year: req.params.year,
      volume: req.params.volume,
      number: req.params.number,
      sections: []
    )

    req.assert('year', 'Wrong year format required.').isInt()
    req.assert('volume', 'Wrong volume format required.').isInt()
    req.assert('number', 'Wrong number format required.').isInt()

    errors = req.validationErrors()
    if errors
      return res.status(400).json errors

    issue.save (err) ->
      if err
        if err.code is 11000
          return res.status(400).send 'Issue already exists.'
        return res.status(400).send 'Unknown error occured.'
      res.json issue

  updateIssue: (req, res) ->
    req.assert('year', 'Wrong year format required.').isInt()
    req.assert('volume', 'Wrong volume format required.').isInt()
    req.assert('number', 'Wrong number format required.').isInt()
    errors = req.validationErrors()
    if errors
      return res.status(400).json errors

    IssueModel.findOne(req.params, (err, document) ->
      if err
        return res.json 500, err: err
      if not document?
        return res.json 500, err: {msg: 'Issue does not exist.'}

      document.year = req.body.year
      document.volume = req.body.volume
      document.number = req.body.number

      document.save (err) ->
        if err
          return res.status(400).send 'Unknown error occured.'
        res.json document
    )
