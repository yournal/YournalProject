meanstack = require('meanstack-framework')

module.exports = (grunt) ->
  mean = require('meanstack-buildpack-coffee')(__dirname, grunt, meanstack, 'project')
  mean.build(mean.config, mean.tasks)
