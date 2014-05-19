module.exports = function($router, $route, $views) {
  $route.get('/', function(req, res) {
    return $views.index.render(req, res);
  });
  return $router.use('/', $route);
};
