module = mean.module 'yournal.services'


module.factory 'user', [
  '$q',
  '$timeout',
  '$http',
  '$location',
  ($q, $timeout, $http, $location) ->
    authenticated: true
    firstName: null
    lastName: null
    email: null
    roles: []

    isAuthenticated: (roles) ->
      if not @authenticated
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
        @authenticated = true
        @firstName = data.firstName
        @lastName = data.lastName
        @email = data.email
        @roles = data.roles

    remove: () ->
      @authenticated = false
      @firstName = null
      @lastName = null
      @email = null
      @roles = []

    authorize: (roles) ->
      if roles?
        if typeof roles is 'object'
          for role in roles
            if role is 'authenticated' and @authenticated
              return true
        else if roles is 'authenticated' and @authenticated
          return true

      if not @authenticated
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
