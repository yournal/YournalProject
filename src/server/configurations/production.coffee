mongodb = require 'sails-mongo'
module.exports =
  waterline:
    adapters:
      default: mongodb
      mongodb: mongodb
    connections:
      mongodb:
        adapter: 'mongodb'
        url: process.env.MONGOHQ_URL
  session:
    connection: 'mongodb'
    secret: 'd859c8e09d14e2a5ce78c39ed2104ce4'
    store: (connection) ->
      return new (require('connect-mongo')(require('express-session')))(
        db: 'app24253929'
        url: process.env.MONGOHQ_URL
      )