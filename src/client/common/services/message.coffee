module = mean.module 'yournal.services'

module.factory 'Message', [
  '$rootScope',
  ($rootScope) ->
    messages = []
    return {
      get: ->
        dispatch = []
        angular.copy messages, dispatch
        messages = []
        return dispatch
      add: (message) ->
        if not message.expire
          message.expire = 2000
        if not message.type?
          if message.success
            message.type = 'success'
          else
            message.type = 'danger'
        messages.push message
        $rootScope.$emit 'message'
    }
]
