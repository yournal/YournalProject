module.exports = ($router, $route, $views) ->
  $route.get '/', (req, res) ->
    $views.index.render(req, res)

  $router.use '/', $route
