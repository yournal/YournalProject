module = meanstack.module 'yournal.layout', ['yournal.layout.header']

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('404',
      url: '/*resource'
      templateUrl: module.mean.resource('layout/404.html')
    )
]
