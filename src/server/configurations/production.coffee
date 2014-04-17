mongodb = require 'sails-mongo'
module.exports =
  waterline:
    adapters:
      default: mongodb
      mongodb: mongodb
    connections:
      mongodb:
        adapter: 'mongodb'
        url: 'mongodb://localhost/mydb'
  session:
    store: (connection) ->
      return new (require('connect-mongo')(require('express-session')))(
        url: 'mongodb://localhost/mydb'
      )