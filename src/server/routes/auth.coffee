exports.route = ($route, $views, passport, token, csrf, auth, UserCtrl) ->
  $route.get '/admin/*', auth(['admin']), (req, res) ->
    $views.index.render(req, res)

  $route.get '/auth', token, (req, res) ->
    if req.isAuthenticated()
      res.json req.user
    else
      res.send 'unauthorized'

  $route.post '/login', csrf, passport.authenticate('local',
    failureFlash: true
  ), (req, res) ->
    res.json req.user

  $route.delete '/logout', (req, res) ->
    req.logOut()
    res.send 200

  $route.post '/register', UserCtrl.create
