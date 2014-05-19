path = require 'path'

module.exports = (config) ->
  appext = path.extname __filename
  if appext is '.js'
    src = path.normalize("#{__dirname}/lib/server")
  else
    src = path.normalize("#{__dirname}/src/server")
  require('meanstack-framework').project(__dirname, src, appext, config)
