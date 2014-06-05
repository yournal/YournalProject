injector = require('./app.coffee').init()
injector.resolve require('meanstack-framework').server
module.exports = injector
