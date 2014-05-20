module.exports = ($router, $route, auth, ArticleCtrl) ->
  $route.get '/articles', (req, res) ->
    ArticleCtrl.getArticles req, res

  $route.get '/articles/:id', (req, res) ->
    ArticleCtrl.getArticle req, res

  $route.get '/articles/new/:t/:a/:k/:abstract/:content', auth, (req, res) ->
    ArticleCtrl.createArticle req, res

  $router.use '/api', $route
