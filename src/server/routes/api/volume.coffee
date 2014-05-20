module.exports = ($router, $route, auth, VolumeCtrl) ->
  $route.get '/volumes', (req, res) ->
    VolumeCtrl.getVolumes req, res

  $route.get '/volumes/:id', (req, res) ->
    VolumeCtrl.getVolume req, res

  $route.get '/volumes/new/:number', auth, (req, res) ->
    VolumeCtrl.createVolume req, res

  $router.use '/api', $route
