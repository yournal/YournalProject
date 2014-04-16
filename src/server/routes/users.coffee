module.exports = (app, controllers) ->
  app.get '/', (req, res) ->
    res.render 'index'

  app.get '/users', controllers.users.list

  app.get '/users/create/:username', controllers.users.create