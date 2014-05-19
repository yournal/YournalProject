module.exports = ($app, $ext) ->
  [
    callback: (req, res, next) ->
      $app req, res, next
    hostnames: []
    paths: []
    protocols: []
    ports: []
    methods: []
  ]
