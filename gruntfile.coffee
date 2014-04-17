path = require 'path'
fs = require 'fs'
module.exports = (grunt) ->
  # Task configuration
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    assets: grunt.file.readJSON 'assets.json'
    concurrent:
      development:
        tasks: ['nodemon', 'watch']
        options:
          logConcurrentOutput: true
      production:
        tasks: ['nodemon']
        options:
          logConcurrentOutput: true
    nodemon:
      dev:
        script: 'src/server/bootstrap.coffee'
        options:
          watch: ['src/server/**/*', 'assets.json', '.restart']
          ignore: ['src/server/styles/**']
          ext: 'coffee,html,json'
          delay: 0
          cwd: __dirname
          env:
            NODE_ENV: 'development'
            PORT: '3000'
            LOGGER: 'off'
          callback: (nodemon) ->
            nodemon.on 'log', (event) ->
              console.log event.colour
            nodemon.on 'restart', () ->
              setTimeout () ->
                fs.writeFileSync '.reload', 'reload'
              , 1000
    watch:
      coffeeClient:
        files: ['src/client/**/*.coffee']
        tasks: ['coffeelint:client', 'coffee:clientDevelopment',
            'copy:coffeeClient', 'replace']
        options:
          spawn: false
          livereload: true
      coffeeServer:
        files: ['src/server/**/*.coffee']
        tasks: ['coffeelint:server']
        options:
          spawn: false
      stylesClient:
        files: ['src/client/styles/**/*.less']
        tasks: ['lesslint', 'less:client']
        options:
          spawn: false
          livereload: true
      stylesServer:
        files: ['src/server/styles/**/*.less']
        tasks: ['lesslint', 'less:server']
        options:
          spawn: false
          livereload: true
      views:
        files: ['src/client/views/**/*.*']
        tasks: ['copy:viewsClient']
        options:
          spawn: false
          livereload: true
      nodemon:
        files: ['.reload', '.restart', 'public/**/*',
          '!public/css/**/*', '!public/js/**/**', '!public/vendor/**/**']
        options:
          livereload: true
    coffee:
      clientProduction:
        expand: true
        cwd: 'src/client/'
        src: ['**/*.coffee']
        dest: 'public/js/'
        ext: '.js'
      clientDevelopment:
        options:
          sourceMap: true
        expand: true
        cwd: 'src/client/'
        src: ['**/*.coffee']
        dest: 'public/js/'
        ext: '.js'
      server:
        expand: true
        cwd: 'src/server/'
        src: ['**/*.coffee']
        dest: 'lib/'
        ext: '.js'
    coffeelint:
      client: ['src/client/**/*.coffee']
      server: ['src/server/**/*.coffee']
    copy:
      coffeeClient:
        files: [
          expand: true
          cwd: 'src/client/'
          src: '**/*.coffee'
          dest: 'public/js/'
        ]
      viewsClient:
        files: [
          expand: true
          cwd: 'src/client/views/'
          src: '**/*.*'
          dest: 'public/views/'
        ]
      viewsServer:
        files: [
          expand: true
          cwd: 'src/server/views/'
          src: '**/*.*'
          dest: 'lib/views/'
        ]
    clean:
      all: ['lib/**/*', 'public/js/**/*', 'public/css/**/*', 'public/views']
    uglify:
      options:
        mangle:
          except: ['jQuery']
        compress:
          drop_console: true
      production:
        files: '<%= assets.js %>'
    replace:
      sourcemap:
        src: ['public/js/**/*.js.map']
        overwrite: true
        replacements: [
          from: /\s*.*?sourceRoot.*?\,/g
          to: ''
        ]
    less:
      client:
        options:
          paths: ['src/client/styles/**']
          sourceMap: true
          outputSourceFiles: true
        expand: true
        cwd: 'src/client/styles/'
        src: '**/*.less'
        dest: 'public/css/client/'
        ext: '.css'
      server:
        options:
          paths: ['src/server/styles/**']
          sourceMap: true
          outputSourceFiles: true
        expand: true
        cwd: 'src/server/styles/'
        src: '**/*.less'
        dest: 'public/css/server/'
        ext: '.css'
    lesslint:
      options:
        csslint:
          'adjoining-classes': false
          'box-sizing': false
          'important': false
          'box-model': false
        less:
          paths: ['src/server/styles/**', 'src/client/styles/**']
          imports: ['src/server/styles/**', 'src/client/styles/**']
      src: ['src/server/styles/**/*.less', 'src/client/styles/**/*.less']
    cssmin:
      combine:
        files: '<%= assets.css %>'
    htmlmin:
      production:
        options:
          removeComments: true
          collapseWhitespace: true
        files: [
          {
            expand: true
            cwd: 'src/client/views/'
            src: '**/*.*'
            dest: 'public/views/'
          },
          {
            expand: true
            cwd: 'src/server/views/'
            src: '**/*.*'
            dest: 'lib/views/'
          }
        ]
    assetver:
      js:
        files: '<%= assets.js %>'
      css:
        files: '<%= assets.css %>'

  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-htmlmin'
  grunt.loadNpmTasks 'grunt-nodemon'
  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-lesslint'
  grunt.loadNpmTasks 'grunt-text-replace'

  if process.env.NODE_ENV == 'production'
    grunt.registerTask 'default', ['clean:all', 'copy:viewsClient',
      'copy:viewsServer', 'htmlmin', 'lesslint',
      'less', 'assetver:css', 'cssmin', 'coffeelint', 'coffee:server',
      'coffee:clientProduction', 'assetver:js', 'uglify',
      'concurrent:production']
  else
    grunt.registerTask 'default', ['clean:all', 'copy:viewsClient',
    'lesslint', 'less', 'coffeelint', 'coffee:clientDevelopment',
    'copy:coffeeClient', 'replace', 'concurrent:development']

  grunt.registerTask 'develop', ['clean:all', 'copy:viewsClient',
    'lesslint', 'less', 'coffeelint', 'coffee:clientDevelopment',
    'copy:coffeeClient', 'replace', 'concurrent:development']
  grunt.registerTask 'release', ['clean:all', 'copy:viewsClient',
    'copy:viewsServer', 'htmlmin', 'lesslint',
    'less', 'assetver:css', 'cssmin', 'coffeelint', 'coffee:server',
    'coffee:clientProduction', 'assetver:js', 'uglify']
  grunt.registerTask 'test', ['clean:all', 'copy:viewsClient',
    'copy:viewsServer', 'htmlmin', 'lesslint',
    'less', 'assetver:css', 'cssmin', 'coffeelint', 'coffee:server',
    'coffee:clientProduction', 'assetver:js', 'uglify']

  # Asset versioning
  crypto = require('crypto')
  fs = require 'fs'
  assets = grunt.file.readJSON 'assets.json'
  grunt.registerMultiTask 'assetver', 'Version assets', () ->
    rev = ''
    modified = false
    for file in @files
      hash = ''
      for source in file.src
        hash += crypto.createHash('md5').update(
          grunt.file.read(source, 'utf8')
        ).digest('hex')
      if file.src.length > 1
        hash = crypto.createHash('md5').update(hash).digest('hex')
      rev = hash.substr(0, 10)
      for type of assets
        if assets[type][file.dest]?
          basename = path.basename(file.dest)
          chunks = basename.split('.')
          if chunks.length == 2
            chunks.splice 1, 0, rev
          else if chunks.length > 2
            chunks.splice chunks.length - 2, 1, rev
          else
            break
          modname = chunks.join '.'
          if basename == modname
            break
          assets[type][file.dest.replace(basename, modname)] =
            assets[type][file.dest]
          delete assets[type][file.dest]
          modified = true
          break
    if modified
      grunt.config 'assets', assets
      fs.writeFileSync('assets.json', JSON.stringify(assets, null, 4))

  # React on single file
  grunt.event.on 'watch', (action, filepath, target) ->
    if action == 'added' || action == 'deleted'
        fs.writeFileSync '.restart', 'restart'

    coffeeConfig = grunt.config 'coffee'
    copyConfig = grunt.config 'copy'
    replaceConfig = grunt.config 'replace'
    coffeelintConfig = grunt.config 'coffeelint'
    lessConfig = grunt.config 'less'
    lesslintConfig = grunt.config 'lesslint'
    if target == 'coffeeServer'
      # Coffeelint
      coffeelintConfig.server = filepath
      grunt.config 'coffeelint', coffeelintConfig
    else if target == 'coffeeClient'
      # Coffeelint
      coffeelintConfig.client = filepath
      grunt.config 'coffeelint', coffeelintConfig
      # Coffee
      coffeeConfig.clientDevelopment.src = path.relative \
        coffeeConfig.clientDevelopment.cwd, filepath
      grunt.config 'coffee', coffeeConfig
      # Copy
      copyConfig.coffeeClient.files[0].src = path.relative \
        copyConfig.coffeeClient.files[0].cwd, filepath
      grunt.config 'copy', copyConfig
      # Replace
      mapfilepath = path.join 'public/js/',
        path.relative('src/client/', filepath).replace('.coffee', '.js.map')
      replaceConfig.sourcemap.src = mapfilepath
      grunt.config 'replace', replaceConfig
    else if target == 'views'
      # Copy
      copyConfig.viewsClient.files[0].src = path.relative \
        copyConfig.viewsClient.files[0].cwd, filepath
      grunt.config 'copy', copyConfig
    else if target == 'stylesServer'
      # Lesslint
      lesslintConfig.src = filepath
      grunt.config 'lesslint', lesslintConfig
      # Less
      lessConfig.server.src = path.relative \
        lessConfig.server.cwd, filepath
      grunt.config 'less', lessConfig
    else if target == 'stylesClient'
      # Lesslint
      lesslintConfig.src = filepath
      grunt.config 'lesslint', lesslintConfig
      # Less
      lessConfig.client.src = path.relative \
        lessConfig.client.cwd, filepath
      grunt.config 'less', lessConfig