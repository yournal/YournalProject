module.exports = ($app, $injector, UserModel) ->
  passport = require 'passport'

  passport.serializeUser (user, done) ->
    done null, user.id

  passport.deserializeUser (id, done) ->
    UserModel.findOne _id: id, '-salt -hashedPassword', (err, user) ->
      done err, user

  # Local strategy
  LocalStrategy = require('passport-local').Strategy
  passport.use new LocalStrategy({
    usernameField: 'email',
    passwordField: 'password'
  }, (email, password, done) ->
    UserModel.findOne(email: email, (err, user) ->
      if err
        return done err
      if not user
        return done null, false, message: 'Unknown user.'
      if not user.authenticate password
        return done null, false, message: 'Invalid password.'
      return done null, user
    )
  )

  # Register passport middleware
  $app.use passport.initialize()
  $app.use passport.session()

  # Auth middleware
  $injector.register 'auth', -> (roles) -> (req, res, next) ->
    if !req.isAuthenticated()
      res.send 401, 'Unauthorized access.'
    else
      if roles?
        authenticated = false
        if typeof roles is 'object'
          for role in roles
            if role in req.user.roles
              authenticated = true
              break
        else
          if roles in req.user.roles
            authenticated = true
        if not authenticated
          res.send 401, 'Unauthorized access.'
        else
          next()
      else
        next()

  return passport
