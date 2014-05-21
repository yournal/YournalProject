module.exports = ($router, $route, $views, passport, auth, UserCtrl) ->
  $route.get '/admin/*', auth, (req, res) ->
    $views.index.render(req, res)

  $route.get '/logged', (req, res) ->
    if req.isAuthenticated()
      res.json req.user
    else
      res.send 'unauthorized'

  $route.post '/login',  passport.authenticate('local',
    failureFlash: true
  ), (req, res) ->
    res.json req.user

  $route.delete '/logout', (req, res) ->
    req.logOut()
    res.send 200

  $route.post '/register', UserCtrl.create

  $router.use '/', $route
