module = mean.module 'yournal.services'

module.factory 'User', [
  '$q',
  '$timeout',
  '$http',
  '$location',
  ($q, $timeout, $http, $location) ->
    authorized: true
    firstName: null
    lastName: null
    email: null
    roles: []

    isAuthorized: (roles) ->
      if not @authorized
        return false
      if roles?
        if typeof roles is 'object'
          for role in roles
            if role in @roles
              return true
        else
          if roles in @roles
            return true
        return false
      return true

    set: (data) ->
      if data
        @authorized = true
        @firstName = data.firstName
        @lastName = data.lastName
        @email = data.email
        @roles = data.roles

    remove: () ->
      @authorized = false
      @firstName = null
      @lastName = null
      @email = null
      @roles = []

    authorize: (roles) ->
      if roles?
        if typeof roles is 'object'
          for role in roles
            if role is 'authorized' and @authorized
              return true
        else if roles is 'authorized' and @authorized
          return true

      if not @authorized
        return false
      if roles?
        if typeof roles is 'object'
          for role in roles
            if role in @roles
              return true
        else
          if role in @roles
            return true
      else
        return true

      return false
]
