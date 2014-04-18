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
        database: 'app24253929'
  session:
    connection: 'mongodb'
    secret: 'd859c8e09d14e2a5ce78c39ed2104ce4'
    store: (connection) ->
      return new (require('connect-mongo')(require('express-session')))(
        host: 'localhost'
        port: 27017
        user: ''
        password: ''
        db: 'app24253929'
        collection: 'sessions'
      )