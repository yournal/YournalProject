mongodb = require 'sails-mongo'
module.exports =
  waterline:
    adapters:
      default: mongodb
      mongodb: mongodb
    connections:
      mongodb:
        adapter: 'mongodb'
        host: 'localhost'
        port: 27017
        user: ''
        password: ''
        database: 'yournal'
  session:
    store: (connection) ->
      return new (require('connect-mongo')(require('express-session')))(
        host: 'localhost'
        port: 27017
        user: ''
        password: ''
        db: 'yournal'
        collection: 'sessions'
      )