path = require 'path'

module.exports.config = ($mean, $config, $dir, $env) ->
  $config.database.uri = process.env.MONGOLAB_URI or process.env.MONGOHQ_URL or process.env.MONGODB_DATABASE or 'mongodb://localhost/yournal'
  $config.secret = '89fds978fs7bc8x2aem3'
  $config.middleware['morgan'] = false # disabled morgan because of grunt
  $config.port = 3000
  $config.views.dir = path.resolve "#{$dir.app}/views/"
  $mean.register 'crypto', -> require 'crypto'

  # Production specificc configuration
  if $env is 'production'
    minify = require('html-minifier').minify
    $config.views.callback = (html) -> # minify html output
      minify html,
        collapseBooleanAttributes: true
        collapseWhitespace: true
        removeAttributeQuotes: true
        removeComments: true
        removeEmptyAttributes: true
        removeRedundantAttributes: true
        removeScriptTypeAttributes: true
        removeStyleLinkTypeAttributes: true

module.exports.beforeRouting = ($mean, $app) ->
  csurf = require('csurf')()

  # CSRF protection
  $mean.register 'csrf', ->
    return (req, res, next) ->
      csurf(req, res, next)

  # CSRF token generator
  $mean.register 'token', ->
    return (req, res, next) ->
      setToken = () ->
        res.cookie 'XSRF-TOKEN', req.csrfToken()
        next()
      if not req.cookies['XSRF-TOKEN']?
        csrf = csurf(req, res, setToken)
        return csrf
      return next()

  $mean.resolve require('./passport')

module.exports.afterRouting = ($app, $views) ->
  $app.all '/api/*', (req, res) ->
    res.send 404, 'Invalid API call.'

  $app.all '/*', (req, res) ->
    res.status 404
    $views.index.render req, res
