var path;

path = require('path');

module.exports = function(config) {
  var appext, src;
  appext = path.extname(__filename);
  if (appext === '.js') {
    src = path.normalize("" + __dirname + "/lib/server");
  } else {
    src = path.normalize("" + __dirname + "/src/server");
  }
  return require('meanstack-framework').project(__dirname, src, appext, config);
};
