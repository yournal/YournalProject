path = require 'path'
src = path.normalize("#{__dirname}/src/server")
module.exports = require('meanstack-framework')(__dirname, src, '.coffee')
