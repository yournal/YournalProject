http = require 'http'

module.exports = ($server, $config) ->
  port = process.env.PORT or $config.port
  http.createServer($server).listen port, ->
    console.log 'Server listening on port ' + port
