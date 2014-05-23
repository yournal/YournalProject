exports.route = ($route, csrf, auth, JournalCtrl) ->
  $route.get '/journal', (req, res) ->
    JournalCtrl.getJournal req, res

  $route.put '/journal', auth(['admin']), csrf, (req, res) ->
    JournalCtrl.updateJournal req, res

  return '/api'
