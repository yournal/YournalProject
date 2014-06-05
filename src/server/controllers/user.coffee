exports.UserCtrl = (UserModel) ->

  create: (req, res, next) ->
    user = new UserModel req.body
    user.provider = 'local'

    req.assert('firstName', 'First name is required.').notEmpty()
    req.assert('lastName', 'Last name can not be empty.').notEmpty()
    req.assert('email', 'You must enter a valid email address.').isEmail()
    req.assert('password', 'Password must be between 8-20 characters long.').len(8, 20)
    req.assert('confirmPassword', 'Passwords do not match.').equals(req.body.password)

    errors = req.validationErrors()
    if errors
      return res.status(400).json errors

    UserModel.count {}, (err, count) ->
      if count is 0
        user.roles = ['admin']
      else
        user.roles = ['user']

      user.save (err) ->
        if err
          if err.code is 11000
            return res.status(400).send 'Email is already registered.'
          return res.status(400).send 'Unknown error occured.'

        req.logIn user, (err) ->
          if err
            return next err
          return res.redirect '/'

        res.status 200
