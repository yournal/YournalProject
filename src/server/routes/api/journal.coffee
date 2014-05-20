module.exports = ($router, $route, auth, JournalCtrl) ->
  $route.get '/journals', (req, res) ->
    JournalCtrl.getJournals req, res

  $route.get '/journals/:id', (req, res) ->
    JournalCtrl.getJournal req, res

  $route.get '/journals/new/:t/:d', auth, (req, res) ->
    JournalCtrl.createJournal req, res

  $router.use '/api', $route
