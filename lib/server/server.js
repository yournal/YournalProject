var http;

http = require('http');

module.exports = function($server, $config) {
  var port;
  port = process.env.PORT || $config.port;
  return http.createServer($server).listen(port, function() {
    return console.log('Server listening on port ' + port);
  });
};
