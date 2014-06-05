module = angular.module 'yournal.layout', []

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('404',
      url: '/404'
      templateUrl: 'public/yournal/js/layout/layout-404.html'
    )
    $stateProvider.state('error',
      url: '/*resource'
      templateUrl: 'public/yournal/js/layout/layout-404.html'
    )
]

module.controller 'yournal.layout.HeaderCtrl', [
  '$rootScope',
  '$scope',
  'User',
  'Message',
  ($rootScope, $scope, User, Message) ->
    $scope.collapsed = true
    $scope.user = User
]

module.controller 'yournal.layout.MessageCtrl', [
  '$rootScope',
  '$scope',
  '$sce',
  '$timeout',
  'User',
  'Message',
  ($rootScope, $scope, $sce, $timeout, User, Message) ->
    $rootScope.$on 'message', ->
      messages = Message.get()
      for message in messages
        message.msg = $sce.trustAsHtml(message.msg)
        if message.expire > 0
          if message.persist? and message.persist is -1
            continue
          $timeout(
            -> message.expired = true,
            3000
          )
      $scope.messages = messages

    $rootScope.$on '$stateChangeStart', ->
      for key, msg of $scope.messages
        if not msg.persist?
          msg.persist = 1
        if msg.persist is -1
          continue
        else if msg.persist > 0
          msg.persist--
        else
          $scope.messages.splice key, 1

    if not User.isAuthorized()
      text = '<h4>Admin panel access</h4>User: test@test.com<br>Password: test1234'
      Message.add
        msg: text
        type: 'info'
        persist: -1
        expire: 0

]
