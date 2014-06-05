var injector = require('./app.js').init();
injector.resolve(require('meanstack-framework').server);
module.exports = injector;
