module.exports = ($router, $route, auth, SectionCtrl) ->
  $route.get '/sections', (req, res) ->
    SectionCtrl.getSections req, res

  $route.get '/sections/:id', (req, res) ->
    SectionCtrl.getSection req, res

  $route.get '/sections/new/:t/:a/:p', auth, (req, res) ->
    SectionCtrl.createSection req, res

  $router.use '/api', $route
