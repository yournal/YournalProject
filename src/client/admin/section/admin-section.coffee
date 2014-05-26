module = mean.module 'yournal.admin.section'

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('section-new',
      url: '/admin/section/new'
      templateUrl: module.mean.resource('admin/section/admin-section-new.html')
      controller: module.mean.namespace('NewCtrl')
      data:
        access:
          allow: ['admin']
          state: 'login'
    )
    $stateProvider.state('section-edit',
      url: '/admin/section/edit/:year/:volume/:number/:section'
      templateUrl: module.mean.resource('admin/section/admin-section-edit.html')
      controller: module.mean.namespace('EditCtrl')
      data:
        access:
          allow: ['admin']
          state: 'login'
      resolve:
        section: ['$rootScope', '$state', '$stateParams', 'Section', 'Message',
          ($rootScope, $state, $stateParams, Section, Message) ->
            $rootScope.loading = true
            Section.get(
              year: $stateParams.year
              volume: $stateParams.volume
              number: $stateParams.number
              section: $stateParams.section
            ,
              (response) ->
                return
            ,
              (err) ->
                Message.add
                  success: false
                  persist: 1
                  expire: -1
                  msg: 'Section not found.'
                $state.go '404'
            ).$promise
        ]
    )
]

module.controller module.mean.namespace('NewCtrl'), [
  '$scope',
  'Issue',
  'Section',
  ($scope, Issue, Section) ->
    $scope.issues = Issue.query(filter: ['sections'])

    $scope.createSection = () ->
      section = new Section(
        title: $scope.title
        abbreviation: $scope.abbreviation
        policyStatement: $scope.policyStatement
      )
      section.$save
        year: $scope.year
        volume: $scope.volume
        number: $scope.issue
      ,
        (response) ->
          $scope.response = response
          $scope.error = []
          $scope.title = ''
          $scope.abbreviation = ''
          $scope.policyStatement = ''
      ,
        (err) ->
          $scope.response = null
          if typeof err.data isnt 'object'
            $scope.error = [msg: err.data]
          else
            $scope.error = err.data
]

module.controller module.mean.namespace('EditCtrl'), [
  '$scope',
  '$stateParams',
  'section',
  'Section'
  ($scope, $stateParams, section, Section) ->
    $scope.section = section
    $scope.error = []
    $scope.response = null
    $scope.updateSection = () ->
      Section.update
        year: $stateParams.year
        volume: $stateParams.volume
        number: $stateParams.number
        section: $stateParams.section
      ,
        section
      ,
        (response) ->
          $scope.response = response
          $scope.error = []
      ,
        (err) ->
          $scope.response = null
          if typeof err.data isnt 'object'
            $scope.error = [msg: err.data]
          else
            $scope.error = err.data

]

module.controller module.mean.namespace('DeleteCtrl'), [
  '$scope',
  '$rootScope',
  '$stateParams',
  'Section',
  'Message',
  ($scope, $rootScope, $stateParams, Section, Message) ->
    $scope.delete = (year, volume, number, section, redirect) ->
      data =
        year: parseInt year
        volume: parseInt volume
        number: parseInt number
        section: section

      Section.delete(
        data
      ,
        (response) ->
          Message.add
            success: true
            msg: 'Section "' + response.title + '" successfully deleted.'

          if redirect
            if redirect is 'reload'
              $state.go($state.current, $stateParams,
                reload: true
                inherit: false
                notify: true
              )
            else if redirect is 'previous'
              $state.go $state.previous
            else
              $state.go redirect
      ,
        (err) ->
          if err.data?
            err = err.data
            if err.err?
              if err.err.msg?
                err = err.err.msg
              else
                err = 'Unkown error.'
          Message.add
            success: false
            msg: err
      )
]
