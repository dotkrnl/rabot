# This file includes codes from Jason Lau's previous project

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    jade:
      install:
        cwd: './frontend'
        src: ['./**/*.jade']
        dest: './public'
        ext: '.html'
        extDot: 'last'
        expand: true
        options:
          doctype: 'html'

    sass:
      install:
        options:
          style: 'expanded'
        files: [{
          expand: true
          cwd: './frontend/scss'
          src: ['./**/*.scss']
          dest: './public/css'
          ext: '.css'
        }]

    bower:
      install:
        dest: 'public'
        js_dest: 'public/js'
        css_dest: 'public/css'
        fonts_dest: 'public/fonts'
        options:
          packageSpecific:
            bootstrap:
              keepExpandedHierarchy: false
              files: [
                "dist/js/bootstrap.min.js",
                "dist/css/bootstrap.min.css",
                "dist/css/bootstrap-theme.min.css"
                "dist/fonts/*"
              ]
            jquery:
              keepExpandedHierarchy: false
              files: [
                "dist/jquery.min.js"
              ]
            'Snap.svg':
              keepExpandedHierarchy: false
              files: [
                "dist/snap.svg-min.js"
              ]
            codemirror:
              keepExpandedHierarchy: false
              files: [
                "lib/*"
              ]
            'iced-coffee-script':
              keepExpandedHierarchy: false
              files: [
                "extras/iced-coffee-script-108.0.8-min.js",
              ]

    browserify:
      install:
        files:
          'public/js/site.js': ['frontend/coffee/**/app.coffee']
        options:
          transform: ['coffeeify']

    connect:
      server:
        options:
          base: "./public"
          port: 9000
          middleware: (connect, options, defaultMiddleware) ->
            return [require('grunt-connect-proxy/lib/utils').proxyRequest]. \
              concat(defaultMiddleware)
        proxies: [{
          context: '/backend',
          host: 'localhost',
          port: 8000,
          https: false,
          xforward: false,
        }]

    watch:
      jade:
        files: ['frontend/**/*.jade']
        tasks: ['jade']
      sass:
        files: ['./frontend/scss/**/*.scss']
        tasks: ['sass']
      browserify:
        files: ['frontend/coffee/**/*.coffee']
        tasks: ['browserify']

  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-bower'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-connect-proxy'

  grunt.registerTask 'compile', ['jade', 'sass', 'bower', 'browserify']
  grunt.registerTask 'serve', ['compile', 'configureProxies:server', 'connect', 'watch']
  grunt.registerTask 'dev', ['compile']
  grunt.registerTask 'default', ['dev']
