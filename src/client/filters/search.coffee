filter = () ->
  return (text) ->
    console.log text
    return true

app = angular.module 'yournal.filters'
app.filter 'search', filter