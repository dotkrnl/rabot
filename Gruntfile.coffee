#This file includes codes from LiuJiaChang's previous project

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
          #filters:
          #  'coffee-script': require('coffee-script').compile
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
            'coffee-script':
              keepExpandedHierarchy: false
              files: [
                "extras/coffee-script.js"
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
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-bower'

  grunt.registerTask 'compile', ['jade', 'sass', 'coffee', 'bower']
  grunt.registerTask 'dev', ['compile']
  grunt.registerTask 'default', ['dev']
