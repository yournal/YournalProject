filter = (version) ->
  return (text) ->
    return String(text).replace /\%VERSION\%/mg, version

app = angular.module 'yournal.filters', []
app.filter 'interpolate', ['version', filter]