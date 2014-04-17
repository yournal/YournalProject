enter = () ->
  return (scope, element, attrs) ->
    element.bind("keydown keypress", (event) ->
      if (event.which == 13)
        scope.$apply(() ->
          scope.$eval(attrs.yournalEnter)
        )
        event.preventDefault()
    )

app = angular.module 'yournal.directives'
app.directive 'yournalEnter', enter