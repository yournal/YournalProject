var path = require('path');
var src = path.normalize(__dirname + '/lib/server');
module.exports = require('meanstack-framework')(__dirname, src, '.js');
