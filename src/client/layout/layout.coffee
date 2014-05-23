module = mean.module 'yournal.layout'

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('404',
      url: '/404'
      templateUrl: module.mean.resource('layout/layout-404.html')
    )
    $stateProvider.state('error',
      url: '/*resource'
      templateUrl: module.mean.resource('layout/layout-404.html')
    )
]

module.controller module.mean.namespace('HeaderCtrl'), [
  '$scope',
  '$rootScope',
  'User',
  'Message',
  ($scope, $rootScope, User, Message) ->
    $scope.collapsed = true
    $scope.user = User
]

module.controller module.mean.namespace('MessageCtrl'), [
  '$scope',
  '$rootScope',
  '$sce',
  'Message',
  ($scope, $rootScope, $sce, Message) ->



    $rootScope.$on 'message', ->
      messages = Message.get()
      for message in messages
        message.msg = $sce.trustAsHtml(message.msg)
      $scope.messages = messages


    text = '<h4>Admin panel access</h4>User: test@test.com<br>Password: test1234'
    Message.add
      msg: text
      type: 'info'





]
