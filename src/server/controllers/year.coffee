module.exports = ($views, YearModel) ->

  getYears: (req, res) ->
    YearModel.find({}, (err, json) ->
      if err
        return res.json
          err: err
          500
      res.send json
    )

  getYear: (req, res) ->
    YearModel.find(req.params.id, (err, json) ->
      if err
        return res.json
          err: err
          500
      res.send json
    )

  createYear: (req, res) ->
    year = new YearModel(
      number: req.params.year,
      volumes: []
    )
    year.save (err) ->
      if err
        return res.json
          err: err
          500
      res.send 'Year created.'