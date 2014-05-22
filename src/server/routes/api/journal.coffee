exports.route = ($route, auth, JournalCtrl) ->
  #$route.get '/journals', (req, res) ->
  #  JournalCtrl.getJournals req, res

  #$route.get '/journals/:id', (req, res) ->
  #  JournalCtrl.getJournal req, res

  #$route.post '/journals/new/:t/:d', auth(['admin']), (req, res) ->
  #  JournalCtrl.createJournal req, res

  $route.get '/journal', (req, res) ->
    JournalCtrl.getJournal req, res

  $route.put '/journal', auth(['admin']), (req, res) ->
    JournalCtrl.updateJournal req, res

  return '/api'
