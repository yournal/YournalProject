((window, document) ->
  modules = {}
  meanstack = {}
  meanstack.modules = []

  if window.meanstack?
    meanstack.name = window.meanstack.replace(/[.-_]/g, '.')

  meanstack.module = (name, type, dependencies) ->
    if name of modules
      return modules[name]
    if not type?
      dependencies = []
      type = 'project'
    else if typeof type is 'object'
      dependencies = type
      type = 'project'
    meanstack.modules.push name
    modules[name] = angular.module name, dependencies
    modules[name].mean = {}
    modules[name].mean.name = name
    if type is 'project'
      modules[name].mean.module = (str) ->
        return "#{modules[name].name}.#{str}"
      modules[name].mean.asset = (str) ->
        return "public/#{str}"
      modules[name].mean.resource = (str) ->
        return "public/js/#{str}"
    else if type is 'plugin'
      modules[name].mean.module = (str) ->
        return "#{modules[name].name}.#{str}"
      modules[name].mean.asset = (str) ->
        return "public/plugins/#{modules[name].mean.name}/#{str}"
      modules[name].mean.resource = (str) ->
        return "public/plugins/#{modules[name].mean.name}/js/#{str}"
    meanstack[name] = modules[name].mean
    return modules[name]

  meanstack.init = (app) ->
    angular.element(document).ready ->
      if meanstack.ready?
        meanstack.ready(app)
      injector = angular.injector(['ng'])
      $http = injector.get('$http')
      $http.get('/mean.json').then (response) ->
        if not meanstack.name?
          meanstack.name = response.data.name
        meanstack.mount = response.data.mount
        meanstack.assets = response.data.assets
        for name in meanstack.modules
          nodename = name.replace(/[.-_]/g, '-')
          if meanstack.assets[nodename]?
            meanstack[name].assets = meanstack.assets[nodename]
        app.constant '$mean', meanstack
        if not meanstack.boostrap?
          angular.bootstrap document, [app.name]
        else
          meanstack.boostrap(app)
    return

  window.meanstack = meanstack
)(window, document)
