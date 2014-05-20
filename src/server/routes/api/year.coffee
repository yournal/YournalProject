module.exports = ($router, $route, auth, YearCtrl) ->
  $route.get '/years', (req, res) ->
    YearCtrl.getYears req, res

  $route.get '/years/:id', (req, res) ->
    YearCtrl.getYear req, res

  $route.get '/years/new/:year', auth, (req, res) ->
    YearCtrl.createYear req, res

  $router.use '/api', $route
