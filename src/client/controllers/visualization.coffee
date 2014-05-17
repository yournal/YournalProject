controller = ($scope) ->

  $scope.data = {
    nodes: [
      {"name":"AAAAAA","group":1}, {"name":"BBBBBBBB","group":1},
      {"name":"CCCCC","group":1}, {"name":"DDDDD","group":1}
      {"name":"EEE","group":2}, {"name":"GG","group":2}
      {"name":"FF","group":2}, {"name":"HH","group":2}
    ]
    links: [
      {"source":0,"target":2,"value":1},
      {"source":0,"target":3,"value":1},
      {"source":0,"target":2,"value":1},
      {"source":0,"target":3,"value":1},
      {"source":0,"target":4,"value":1},
      {"source":0,"target":5,"value":1},
      {"source":0,"target":6,"value":1},
      {"source":0,"target":7,"value":1},
      {"source":0,"target":7,"value":1},
      {"source":1,"target":2,"value":1},
      {"source":1,"target":3,"value":1},
      {"source":1,"target":2,"value":1},
      {"source":1,"target":3,"value":1},
      {"source":1,"target":4,"value":1},
      {"source":1,"target":5,"value":1},
      {"source":1,"target":6,"value":1},
      {"source":1,"target":7,"value":1},
      {"source":1,"target":7,"value":1}
    ]
  }

app = angular.module 'yournal.controllers'
app.controller 'VisualizationController', [
  '$scope', controller
]
