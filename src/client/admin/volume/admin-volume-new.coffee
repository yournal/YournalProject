module = mean.module 'yournal.admin.volume.new'

module.config [
  '$stateProvider',
  ($stateProvider) ->
    $stateProvider.state('volume-new',
      url: '/admin/volume/new'
      templateUrl: module.mean.resource('admin/volume/admin-volume-new.html')
    )
]
