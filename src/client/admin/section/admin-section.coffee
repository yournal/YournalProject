module = mean.module 'yournal.admin.section'

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('section-new',
      url: '/admin/section/new'
      templateUrl: module.mean.resource('admin/section/admin-section-new.html')
      controller: module.mean.namespace('SectionNewCtrl')
      data:
        access:
          allow: ['admin']
          state: 'login'
    )
    $stateProvider.state('section-edit',
      url: '/admin/section/edit/:year/:volume/:number/:section'
      templateUrl: module.mean.resource('admin/section/admin-section-edit.html')
      controller: module.mean.namespace('SectionEditCtrl')
      data:
        access:
          allow: ['admin']
          state: 'login'
    )
]

module.controller module.mean.namespace('SectionEditCtrl'), [
  '$scope',
  '$stateParams',
  'Section'
  ($scope, $stateParams, Section) ->
    year = parseInt($stateParams.year)
    volume = parseInt($stateParams.volume)
    number = parseInt($stateParams.number)
    sectionId = $stateParams.section

    section = Section.get(
      year: year
      volume: volume
      number: number
      section: sectionId
    ,
      (response) ->
        return
    ,
      (err) ->
        $state.go '404'
    )

    $scope.section = section
    $scope.error = []
    $scope.response = null
    $scope.updateSection = () ->
      Section.update
        year: year
        volume: volume
        number: number
        section: sectionId
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

module.controller module.mean.namespace('SectionNewCtrl'), [
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
