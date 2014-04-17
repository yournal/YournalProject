module.exports =
  express:
    template: 'swig'
    port: process.env.PORT || 3000
  session:
    connection: 'mongodb'
    secret: 'd859c8e09d14e2a5ce78c39ed2104ce4'