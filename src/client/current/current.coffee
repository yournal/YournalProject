module = meanstack.module 'yournal.current', [
  'yournal.services'
]

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('home',
      url: '/'
      templateUrl: module.mean.resource('current/home.html')
      controller: module.mean.module('CurrentCtrl')
    )
    $stateProvider.state('current',
      url: '/current'
      templateUrl: module.mean.resource('current/current.html')
      controller: module.mean.module('CurrentCtrl')
    )
]

module.controller module.mean.module('CurrentCtrl'), [
  '$scope',
  'Journal',
  'Issue',
  'Article',
  'Section',
  ($scope, Journal, Issue, Article, Section) ->
    $scope.journal = Journal.getJournal()
    $scope.issues = Issue.getIssues()
    $scope.articles = Article.getArticles()
    $scope.sections = Section.getSections()
]
