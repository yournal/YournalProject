exports.route = ($route, $views, passport, auth, UserCtrl) ->
  $route.get '/', (req, res) ->
    $views.index.render(req, res)

  $route.get '/404', (req, res) ->
    res.status 404
    $views.index.render(req, res)

  $route.get '/search', (req, res) ->
    $views.index.render(req, res)

  $route.get '/current', (req, res) ->
    $views.index.render(req, res)

  $route.get '/archives', (req, res) ->
    $views.index.render(req, res)

  $route.get '/visualization', (req, res) ->
    $views.index.render(req, res)

  $route.get '/login', (req, res) ->
    $views.index.render(req, res)

  $route.get '/logout', (req, res) ->
    $views.index.render(req, res)

  $route.get '/register', (req, res) ->
    $views.index.render(req, res)

  $route.get '/issue/:year/:volume/:issue', (req, res) ->
    $views.index.render(req, res)

  $route.get '/issue/:year/:volume/:issue/sections/:section/article/:article', (req, res) ->
    $views.index.render(req, res)
