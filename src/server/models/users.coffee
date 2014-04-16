Waterline = require('waterline')
module.exports = Waterline.Collection.extend
  identity: 'users'
  connection: 'mongodb'
  attributes:
    username: 'string'
    firstname: 'string'
    lastname: 'string'
    email: 'string'