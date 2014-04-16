module.exports = (models) ->
  list: (req, res) ->
    models.users.find().done (err, json) ->
      if err
        return res.json
          err: err
          500
      res.json json
  create: (req, res) ->
    models.users.create(
      username: req.params.username
      firstname: req.params.username
      lastname: req.params.username
      email: req.params.username
    ).done (err, user) ->
      if (err)
        console.log err
      else
        console.log 'User created:', req.params.username
