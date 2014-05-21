module = mean.module 'yournal.services'

module.factory 'Error', [
    () ->
      errorList = []
      return {
        get: () ->
          errors = []
          angular.copy errorList, errors
          errorList = []
          return errors
        add: (err) ->
          errorList.push(err)
      }
]