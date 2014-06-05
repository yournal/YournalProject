exports.JournalRoute = ($route, csrf, auth, JournalCtrl) ->
  $route.get '/journal', (req, res) ->
    JournalCtrl.getJournal req, res

  $route.put '/journal', csrf, auth(['admin']), (req, res) ->
    JournalCtrl.updateJournal req, res
