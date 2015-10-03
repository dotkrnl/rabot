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

  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.registerTask 'compile', ['jade', 'sass', 'coffee']
  grunt.registerTask 'dev', ['compile']
  grunt.registerTask 'default', ['dev']
