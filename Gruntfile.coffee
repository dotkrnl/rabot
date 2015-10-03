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

  grunt.loadNpmTasks 'grunt-contrib-jade'

  grunt.registerTask 'compile', ['jade']
  grunt.registerTask 'dev', ['compile']
  grunt.registerTask 'default', ['dev']
