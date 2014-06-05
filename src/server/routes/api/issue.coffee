exports.IssueRoute = ($route, csrf, auth, IssueCtrl) ->
  $route.get '/issues/:year?/:volume?', (req, res) ->
    IssueCtrl.getIssues req, res

  $route.get '/issues/:year/:volume/:number', (req, res) ->
    IssueCtrl.getIssue req, res

  $route.post '/issues/:year/:volume/:number', csrf, auth(['admin']), (req, res) ->
    IssueCtrl.createIssue req, res

  $route.put '/issues/:year/:volume/:number', csrf, auth(['admin']), (req, res) ->
    IssueCtrl.updateIssue req, res

  $route.delete '/issues/:year/:volume/:number', csrf, auth(['admin']), (req, res) ->
    IssueCtrl.deleteIssue req, res
