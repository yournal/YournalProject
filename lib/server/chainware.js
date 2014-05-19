module.exports.config = function($config, $env) {
  $config.database.uri = process.env.MONGODB_DATABASE || 'mongodb://localhost/yournal';
  $config.secret = '89fds978fs7bc8x2aem3';
  $config.middleware['morgan'] = false;
  return $config.port = 3000;
};

module.exports.afterRouting = function($app, $views) {
  return $app.all('/*', function(req, res) {
    return $views.index.render(req, res);
  });
};
