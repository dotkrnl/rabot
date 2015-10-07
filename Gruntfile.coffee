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

    coffee:
      install:
        cwd: './frontend/coffee'
        src: ['./**/*.coffee']
        ext: '.js'
        dest: './public/js'
        expand: true

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
            angular:
              keepExpandedHierarchy: false
              files: [
                "angular.min.js",
              ]
            'angular-route':
              keepExpandedHierarchy: false
              files: [
                "angular-route.min.js",
              ]
            'angular-mocks':
              keepExpandedHierarchy: false
              files: [
                "angular-mocks.js",
              ]
            'iced-coffee-script':
              keepExpandedHierarchy: false
              files: [
                "extras/iced-coffee-script-108.0.8-min.js",
              ]

    connect:
      server:
        options:
          base: "./public"
          port: 9000

    watch:
      jade:
        files: ['frontend/**/*.jade']
        tasks: ['jade']
      sass:
        files: ['./frontend/scss/**/*.scss']
        tasks: ['sass']
      coffee:
        files: ['frontend/coffee/**/*.coffee']
        tasks: ['coffee']

  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-bower'

  grunt.registerTask 'compile', ['jade', 'sass', 'coffee', 'bower']
  grunt.registerTask 'serve', ['compile', 'connect', 'watch']
  grunt.registerTask 'dev', ['compile']
  grunt.registerTask 'default', ['dev']
