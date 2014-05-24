exports.route = ($route, $views, passport, token, csrf, auth, UserCtrl) ->
  $route.get '/admin/*', auth(['admin']), (req, res) ->
    $views.index.render(req, res)

  $route.get '/auth', token, (req, res) ->
    if req.isAuthenticated()
      res.json req.user
    else
      res.send 'unauthorized'

  $route.post '/login', csrf, (req, res, next) ->
    passport.authenticate('local', (err, user, info) ->
      if err?
        return next err
      if not user
        return res.send 401, info.message
      req.logIn user, (err) ->
        if err?
          return next err
        return res.json user
    )(req, res, next)

  $route.delete '/logout', (req, res) ->
    req.logOut()
    res.send 200

  $route.post '/register', UserCtrl.create
