module = mean.module 'yournal.admin.section.new'

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('section-new',
      url: '/admin/section/new'
      templateUrl: module.mean.resource('admin/section/admin-section-new.html')
      data:
        access:
          allow: ['admin']
          state: 'login'
    )
]
