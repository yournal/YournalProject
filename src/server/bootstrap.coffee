path = require 'path'
glob = require 'glob'
_ = require 'lodash'

# Set default environment
if process.env.NODE_ENV == undefined
  process.env.NODE_ENV = 'production'

# Configuration
dic = require('dependable').container()
config = require './configurations/all'
config = _.extend config,
  require './configurations/' + process.env.NODE_ENV || {}
config.path = {}
if process.env.NODE_ENV == 'development'
  config.path.root = path.normalize __dirname + '/../../'
else
  config.path.root = path.dirname require.main.filename
config.path.assets = path.join config.path.root, 'assets.json'
config.path.static = path.join config.path.root, 'public'
dic.register 'config', config

# Express
express = require 'express'
consolidate = require('consolidate')
swig = require 'swig'
assetmanager = require 'assetmanager'
assets = require config.path.assets
assetmanager.init(
  js: assets.js
  css: assets.css
  debug: process.env.NODE_ENV != 'production'
  webroot: 'public'
)
app = express()
app.locals.cache = 'memory' # used for swig in production
if process.env.NODE_ENV == 'development'
  app.set 'showStackError', true
  if process.env.LOGGER == 'on'
    app.use require('morgan')('dev')
else
  app.set 'showStackError', false
app.engine 'html', consolidate[config.express.template]
app.set 'view engine', 'html'
app.set 'views', __dirname + '/views'
app.enable 'jsonp callback'
app.use require('errorhandler')()
app.use require('express-validator')()
app.use require('body-parser')()
app.use require('method-override')()
app.use require('cookie-parser')(config.session.secret)
app.use require('express-session')(
  secret: config.session.secret
  key: 'sid'
  cookie:
    path: '/'
    domain: ''
    httpOnly: true
    maxAge: 60 * 60 * 1000
  store: config.session.store()
)
app.use require('compression')()
app.use (req, res, next) ->
  res.locals.assets = assetmanager.assets
  next()
app.use require('view-helpers')()
app.use require('connect-flash')()
#app.use require('static-favicon')(config.path.static + '/favicon.ico')
app.use express.static(config.path.static)
dic.register 'app', () -> app

# Database
orm = new require('waterline')()

# Init models
glob __dirname + '/models/**/*', {sync: true}, (err, files) ->
  if err
    console.log err
    process.exit 0
  for file in files
    orm.loadCollection require file

# Server
orm.initialize config.waterline, (err, models) ->
  if err
    console.log err
    process.exit 0

  # Load models & connections
  dic.register 'models', models.collections
  dic.register 'connections', models.connections

  # Load controllers
  controllers = {}
  glob __dirname + '/controllers/**/*', {sync: true}, (err, files) ->
    if err
      console.log err
      process.exit 0
    for file in files
      name = path.basename(file).replace(/\..+$/, '')
      controllers[name] = dic.resolve require file
  dic.register 'controllers', controllers

  # Resolve routes
  glob __dirname + '/routes/**/*', {sync: true}, (err, files) ->
    if err
      console.log err
      process.exit 0
    for file in files
      dic.resolve require file

  # Start server
  app.listen config.express.port