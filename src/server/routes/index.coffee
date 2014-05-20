module.exports = ($router, $route, $views, ArticleCtrl, YearCtrl, IssueCtrl, VolumeCtrl, SectionCtrl, JournalCtrl) ->
  $route.get '/', (req, res) ->
    $views.index.render(req, res)

  $route.get '/journals', (req, res) ->
    JournalCtrl.getJournals req, res

  $route.get '/journals/:id', (req, res) ->
    JournalCtrl.getJournal req, res

  $route.get '/journals/new/:t/:d', (req, res) ->
    JournalCtrl.createJournal req, res

  $route.get '/articles', (req, res) ->
    ArticleCtrl.getArticles req, res

  $route.get '/articles/:id', (req, res) ->
    ArticleCtrl.getArticle req, res
  
  $route.get '/articles/new/:t/:a/:k/:abstract/:content', (req, res) ->
    ArticleCtrl.createArticle req, res

  $route.get '/years', (req, res) ->
    YearCtrl.getYears req, res

  $route.get '/years/:id', (req, res) ->
    YearCtrl.getYear req, res

  $route.get '/years/new/:year', (req, res) ->
    YearCtrl.createYear req, res

  $route.get '/issues', (req, res) ->
    IssueCtrl.getIssues req, res

  $route.get '/issues/:id', (req, res) ->
    IssueCtrl.getIssue req, res

  $route.get '/issues/new/:number', (req, res) ->
    IssueCtrl.createIssue req, res

  $route.get '/volumes', (req, res) ->
    VolumeCtrl.getVolumes req, res

  $route.get '/volumes/:id', (req, res) ->
    VolumeCtrl.getVolume req, res

  $route.get '/volumes/new/:number', (req, res) ->
    VolumeCtrl.createVolume req, res

  $route.get '/sections', (req, res) ->
    SectionCtrl.getSections req, res

  $route.get '/sections/:id', (req, res) ->
    SectionCtrl.getSection req, res

  $route.get '/sections/new/:t/:a/:p', (req, res) ->
    SectionCtrl.createSection req, res

  $router.use '/api', $route
