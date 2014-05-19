var appext, mean;

appext = require('path').extname(__filename);

if (appext === '.js') {
  mean = require('./app.js')();
  mean.resolve(require('meanstack-framework').server);
} else {
  mean = require('./app.coffee')();
  mean.resolve(require('meanstack-framework').server);
}

module.exports = mean;
