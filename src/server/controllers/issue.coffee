module.exports = ($views, IssueModel) ->
  getIssue: (req, res) ->
    IssueModel.findOne(req.params, (err, json) ->
      if err
        return res.json
          err: err
          500
      res.json json
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

    IssueModel.find(params, fields, query, (err, json) ->
      if err
        return res.json
          err: err
          500
      res.json json
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
      return res.status(400).send errors

    issue.save (err) ->
      if err
        if err.code is 11000
          return res.status(400).send('Issue already exists.')
        return res.status(400).send('Please fill all the required fields.')
      res.json issue
