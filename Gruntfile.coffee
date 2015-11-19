# This file includes codes from Jason Lau's previous project

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    jade:
      install:
        cwd: './frontend/apps'
        src: ['./**/*.jade']
        dest: './_site'
        ext: '.html'
        extDot: 'last'
        expand: true
        options:
          doctype: 'html'
          basedir: './frontend/'

    sass:
      install:
        options:
          style: 'expanded'
        files: [{
          expand: true
          cwd: './frontend/apps'
          src: ['./site.scss']
          dest: './_site/css'
          ext: '.css'
        }]

    yaml:
      install:
        files: [{
          expand: true
          cwd: './frontend/locales'
          src: ['**/*.yml']
          dest: './_site/locales'
        }]

    copy:
      install:
        files: [{
          expand: true
          cwd: 'frontend/public/'
          src: ['**']
          dest: '_site/public/'
          filter: 'isFile'
        }]

    bower:
      install:
        dest: './_site'
        js_dest: './_site/js'
        css_dest: './_site/css'
        fonts_dest: './_site/fonts'
        options:
          packageSpecific:
            bootstrap:
              keepExpandedHierarchy: false
              files: [
                "dist/js/bootstrap.min.js"
                "dist/css/bootstrap.min.css"
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
                "addon/selection/active-line.js"
                "theme/solarized.css"
              ]
            'iced-coffee-script':
              keepExpandedHierarchy: false
              files: [
                "extras/iced-coffee-script-108.0.8-min.js"
              ]
            'SoundJS':
              keepExpandedHierarchy: false
              files: [
                "lib/soundjs-0.6.1.min.js"
              ]
            'i18next':
              keepExpandedHierarchy: false
              files: [
                "i18next.min.js"
              ]

    browserify:
      install:
        files:
          './_site/js/site.js': ['frontend/apps/**/app.coffee']
        options:
          transform: ['coffeeify']

    connect:
      server:
        options:
          base: "./_site"
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

    shell:
      django:
        command: 'cd backend && python manage.py runserver 0.0.0.0:8000'
        options:
          stdin: true,
          stdout: true,
          stderr: true

    watch:
      copy:
        files: ['./frontend/public/**/*.*']
        tasks: ['copy']
      jade:
        files: ['./frontend/**/*.jade']
        tasks: ['jade']
      sass:
        files: ['./frontend/**/*.scss']
        tasks: ['sass']
      yaml:
        files: ['./frontend/**/*.yml']
        tasks: ['yaml']
      browserify:
        files: ['./frontend/**/*.coffee']
        tasks: ['browserify']

    concurrent:
      runserver:
        tasks: ['shell:django', 'watch']
        options:
          logConcurrentOutput: true

    secret: grunt.file.readJSON('secret.json'),

    sftp:
      deploy:
        files:
          "./": ["_site/**", "backend/**"]
        options:
          path: '/tmp/rabot',
          createDirectories: 'true'
          host: '<%= secret.host %>',
          username: '<%= secret.username %>',
          password: '<%= secret.password %>',
          showProgress: true

    sshexec:
      precopy:
        command: 'uptime',
        options:
          host: '<%= secret.host %>',
          username: '<%= secret.username %>',
          password: '<%= secret.password %>'
      postcopy:
        command: 'uptime',
        options:
          host: '<%= secret.host %>',
          username: '<%= secret.username %>',
          password: '<%= secret.password %>'

  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-bower'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-connect-proxy'
  grunt.loadNpmTasks 'grunt-shell'
  grunt.loadNpmTasks 'grunt-ssh'
  grunt.loadNpmTasks 'grunt-yaml'

  grunt.registerTask 'deploy', ['sshexec:precopy', 'sftp', 'sshexec:postcopy']
  grunt.registerTask 'compile', ['copy', 'jade', 'sass', 'yaml', 'bower', 'browserify']
  grunt.registerTask 'serve', [
    'compile', 'configureProxies:server', 'connect', 'concurrent:runserver']
  grunt.registerTask 'dev', ['compile']
  grunt.registerTask 'default', ['dev']
