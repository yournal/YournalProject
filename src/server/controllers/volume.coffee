module.exports = ($views, VolumeModel) ->

  getVolumes: (req, res) ->
    VolumeModel.find({}, (err, json) ->
      if err
        return res.json
          err: err
          500
      res.send json
    )

  getVolume: (req, res) ->
    VolumeModel.find(req.params.id, (err, json) ->
      if err
        return res.json
          err: err
          500
      res.send json
    )

  createVolume: (req, res) ->
    volume = new VolumeModel(
      number: req.params.number,
      issues: []
    )
    volume.save (err) ->
      if err
        return res.json
          err: err
          500
      res.send 'Volume created.'