module.exports.config = ($mean, $config, $env) ->
  $config.database.uri = \
    process.env.MONGODB_DATABASE or 'mongodb://localhost/yournal'
  $config.secret = '89fds978fs7bc8x2aem3'
  $config.middleware['morgan'] = false
  $config.port = 3000

  $mean.register 'crypto', require 'crypto'

module.exports.beforeRouting = ($mean) ->
  $mean.resolve require('./passport')

module.exports.afterRouting = ($app, $views) ->
  $app.all '/*', (req, res) ->
    res.statusCode = 404
    $views.index.render(req, res)
