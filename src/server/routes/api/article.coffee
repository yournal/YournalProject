exports.ArticleRoute = ($route, csrf, auth, ArticleCtrl) ->
  $route.get '/issues/:year/:volume/:number/sections/:section/articles', (req, res) ->
    ArticleCtrl.getArticles req, res

  $route.get '/articles', (req, res) ->
    ArticleCtrl.getAllArticles req, res

  $route.get '/issues/:year/:volume/:number/sections/:section/articles/:article', (req, res) ->
    ArticleCtrl.getArticle req, res

  $route.post '/issues/:year/:volume/:number/sections/:section/articles', csrf, auth(['admin']), (req, res) ->
    ArticleCtrl.createArticle req, res

  $route.delete '/issues/:year/:volume/:number/sections/:section/articles/:article', csrf, auth(['admin']), (req, res) ->
    ArticleCtrl.deleteArticle req, res

  $route.put '/issues/:year/:volume/:number/sections/:section/articles/:article', csrf, auth(['admin']), (req, res) ->
    ArticleCtrl.updateArticle req, res
