module.exports = ($views) ->
  home: (req, res) ->
    $views.index.render(req, res)
