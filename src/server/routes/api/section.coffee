module.exports = ($router, $route, auth, SectionCtrl) ->
  $route.get '/issues/:year/:volume/:number/sections', (req, res) ->
    SectionCtrl.getSections req, res

  $route.get '/issues/:year/:volume/:number/sections/:section', (req, res) ->
    SectionCtrl.getSection req, res

  $route.post '/issues/:year/:volume/:number/sections', (req, res) ->
    SectionCtrl.createSection req, res

  $route.delete '/issues/:year/:volume/:number/sections/:section', (req, res) ->
    SectionCtrl.deleteSection req, res

  $router.use '/api', $route
