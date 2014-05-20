module.exports = ($router, $route, auth, IssueCtrl) ->
  $route.get '/issues', (req, res) ->
    IssueCtrl.getIssues req, res

  $route.get '/issues/:id', (req, res) ->
    IssueCtrl.getIssue req, res

  $route.get '/issues/new/:number', auth, (req, res) ->
    IssueCtrl.createIssue req, res

  $router.use '/api', $route
