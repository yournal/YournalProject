module.exports = ($router, $route, $views, passport, auth, UserCtrl) ->
  $route.get '/', (req, res) ->
    $views.index.render(req, res)

  $route.get '/search', (req, res) ->
    $views.index.render(req, res)

  $route.get '/current', (req, res) ->
    $views.index.render(req, res)

  $route.get '/archives', (req, res) ->
    $views.index.render(req, res)

  $route.get '/visualization', (req, res) ->
    $views.index.render(req, res)

  $router.use '/', $route
