module.exports = ($router, $route, auth, IssueCtrl) ->
  $route.get '/issues/:year?/:volume?', (req, res) ->
    IssueCtrl.getIssues req, res

  $route.get '/issues/:year/:volume/:number', (req, res) ->
    IssueCtrl.getIssue req, res

  $route.post '/issues/:year/:volume/:number', (req, res) ->
    IssueCtrl.createIssue req, res



  $route.put '/issues/:year/:volume/:number', (req, res) ->
    res.send 'dela'


  $route.delete '/issues/:year/:volume/:number', (req, res) ->
    IssueCtrl.deleteIssue req, res

  $router.use '/api', $route
