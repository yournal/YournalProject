# Bootstrap
angular.element(document).ready ->
  if window.location.hash == '#_=_'
    window.location.hash = '#!'
  angular.bootstrap document, ['yournal']

# Dynamically add angular modules declared by packages
modules = []
for index of window.modules
  dependencies = []
  if window.modules[index].angularDependencies?
    dependencies = window.modules[index].angularDependencies
  angular.module window.modules[index].module, dependencies
  modules.push window.modules[index]

# Register modules
app = angular.module('yournal', modules.concat([
  'ngRoute',
  'ngResource',
  'ngAnimate',
  'yournal.filters',
  'yournal.services',
  'yournal.directives',
  'yournal.controllers',
  'ui.router',
  'ui.unique'
]))

# Register modules
angular.module 'yournal.filters', []
angular.module 'yournal.controllers', []
angular.module 'yournal.services', []
angular.module 'yournal.directives', []

app.config(['$stateProvider', '$urlRouterProvider',
  ($stateProvider, $urlRouterProvider) ->
    $stateProvider.state('home',
      url: '/'
      templateUrl: 'views/home.html'
      controller: 'HomeController'
    )
    $stateProvider.state('current',
      url: '/current'
      templateUrl: 'views/current.html'
      controller: 'HomeController'
    )
    $stateProvider.state('issue',
      url: '/issue/:issueId'
      templateUrl: 'views/issue.html'
      controller: 'IssueController'
    )
    $stateProvider.state('archives',
      url: '/archives'
      templateUrl: 'views/archives.html'
      controller: 'ArchiveController'
    )
    $stateProvider.state('journals',
      url: '/journals'
      templateUrl: 'views/journals.html'
      controller: 'IndexController'
    )
    $stateProvider.state('journal',
      url: '/journals/:journal_id'
      templateUrl: 'views/journal.html'
      controller: 'JournalController'
    )
    $stateProvider.state('search',
      url: '/search'
      templateUrl: 'views/search.html'
      controller: 'SearchController'
    )
    $stateProvider.state('article',
      url: '/article/:articleId'
      templateUrl: 'views/article.html'
      controller: 'ArticleController'
    )
    $urlRouterProvider.otherwise('/')
])
app.config(['$locationProvider', ($locationProvider) ->
  $locationProvider.hashPrefix '!'
])

app.run ($rootScope, $state, $stateParams) ->
  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams