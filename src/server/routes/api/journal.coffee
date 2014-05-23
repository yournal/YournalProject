exports.route = ($route, auth, JournalCtrl) ->
  $route.get '/journal', (req, res) ->
    JournalCtrl.getJournal req, res

  $route.put '/journal', auth(['admin']), (req, res) ->
    JournalCtrl.updateJournal req, res

  return '/api'
