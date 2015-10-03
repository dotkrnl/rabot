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
          filters:
            'coffee-script': require('coffee-script').compile
    sass:
      dist:
        options:
          style: 'expanded'
        files: [{
          expand: true
          cwd: './frontend'
          src: ['./**/*.scss']
          dest: './public'
          ext: '.css'
        }]

  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-jade'

  grunt.registerTask 'compile', ['jade', 'sass']
  grunt.registerTask 'dev', ['compile']
  grunt.registerTask 'default', ['dev']
