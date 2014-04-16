controller = ($scope, Journal, Article, Section) ->
  $scope.journals = Journal.query()
  $scope.articles = Article.query()
  $scope.sections = Section.query()

controllerJournal = ($scope, $routeParams, Journal) ->
  $scope.journal = Journal.get(journal_id: $routeParams.journal_id)
  
app = angular.module 'yournal.controllers'
app.controller 'ExampleController', [
  '$scope', 'Journal', 'Article', 'Section', controller
]
app = angular.module 'yournal.controllers'
app.controller 'JournalController', [
  '$scope', '$routeParams', 'Journal', controllerJournal
]