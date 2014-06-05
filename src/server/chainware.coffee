path = require 'path'

exports.config = ($injector, $config, $dir, $env) ->
  $config.database.uri = process.env.MONGOLAB_URI or process.env.MONGOHQ_URL or process.env.MONGODB_DATABASE or 'mongodb://localhost/yournal'
  $config.secret = '89fds978fs7bc8x2aem3'
  $config.port = 3000
  $config.views.dir = path.resolve "#{$dir.app}/views/"
  $injector.register 'crypto', -> require 'crypto'

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

exports.dependencies = ($injector) ->
  csurf = require('csurf')()

  # CSRF protection
  $injector.register 'csrf', ->
    return (req, res, next) ->
      csurf(req, res, next)

  # CSRF token generator
  $injector.register 'token', ->
    return (req, res, next) ->
      setToken = () ->
        res.cookie 'XSRF-TOKEN', req.csrfToken()
        next()
      csurf(req, res, setToken)

exports.routes = ($injector, $plugin, $router, $assets, $views, $name) ->
  passport = $injector.resolve require('./passport')
  $injector.register 'passport', passport

  obj = {}
  obj['name'] = $name.replace(/[.-_]/g, '.')
  obj['mount'] = '/'
  obj['assets'] = $assets
  $router.get '/data.json', (req, res) ->
    res.json obj

  $router.use '/', $injector.get 'IndexRoute'
  $router.use '/', $injector.get 'AuthRoute'
  $router.use '/api', $injector.get 'SectionRoute'
  $router.use '/api', $injector.get 'JournalRoute'
  $router.use '/api', $injector.get 'IssueRoute'
  $router.use '/api', $injector.get 'ArticleRoute'

  $router.all '/api/*', (req, res) ->
    res.send 404, 'Invalid API call.'

  $router.all '/*', (req, res) ->
    res.status 404
    $views.index.render req, res
