module.exports = ($router, $route, auth, ArticleCtrl) ->
  $route.get '/issues/:year/:volume/:number/sections/:section/articles', (req, res) ->
    ArticleCtrl.getArticles req, res

  $route.get '/articles', (req, res) ->
    ArticleCtrl.getAllArticles req, res

  $route.get '/issues/:year/:volume/:number/sections/:section/articles/:article', (req, res) ->
    ArticleCtrl.getArticle req, res

  $route.post '/issues/:year/:volume/:number/sections/:section/articles', (req, res) ->
    ArticleCtrl.createArticle req, res

  $router.use '/api', $route
