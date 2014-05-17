service = ($document, $q, $rootScope) ->
  d = $q.defer()

  onScriptLoad = () ->
    # Load client in the browser
    $rootScope.$apply () ->
      d.resolve window.d3

  # Create a script tag with d3 as the source and call our
  # onScriptLoad callback when it  has been loaded
  scriptTag = $document[0].createElement 'script'
  scriptTag.type = 'text/javascript'
  scriptTag.async = true
  scriptTag.src = 'http://d3js.org/d3.v3.min.js'
  scriptTag.onreadystatechange = () ->
    if (this.readyState == 'complete')
      onScriptLoad()
  scriptTag.onload = onScriptLoad

  s = $document[0].getElementsByTagName('body')[0]
  s.appendChild scriptTag

  return {
    d3: () ->
      return d.promise
  }


app = angular.module 'yournal.d3'
app.factory 'd3Service', ['$document', '$q', '$rootScope', service ]


