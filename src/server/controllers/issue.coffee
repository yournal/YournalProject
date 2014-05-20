module.exports = ($views, IssueModel) ->

  getIssues: (req, res) ->
    IssueModel.find({}, (err, json) ->
      if err
        return res.json
          err: err
          500
      res.send json
    )

  getIssue: (req, res) ->
    IssueModel.find(req.params.id, (err, json) ->
      if err
        return res.json
          err: err
          500
      res.send json
    )

  createIssue: (req, res) ->
    issue = new IssueModel(
      number: req.params.number,
      sections: []
    )
    issue.save (err) ->
      if err
        return res.json
          err: err
          500
      res.send 'Issue created.'