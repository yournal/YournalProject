module.exports = ($app) ->
  LocalStrategy = require('passport-local').Strategy
  passport = require 'passport'

  passport.serializeUser (user, done) ->
    done null, user.id

  passport.deserializeUser (id, done) ->
    User.findOne _id: id, '-salt -hashedPassword', (err, user) ->
      done err, user

  passport.use new LocalStrategy({
    usernameField: 'email',
    passwordField: 'password'
  }, (email, password, done) ->
    User.findOne(email: email, (err, user) ->
      if err
        return done err
      if not user
        return done null, false, message: 'Unknown user'
      if not user.authenticate password
        return done null, false, message: 'Invalid password'
      return done null, user
    )
  )

  $app.use passport.initialize()
  $app.use passport.session()

