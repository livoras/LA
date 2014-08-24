module.exports = (grunt)->

  coffeeify = require 'coffeeify'
  stringify = require 'stringify'

  grunt.initConfig
    connect:
      server:
        options:
          port: 3000
          base: '.'

    clean: 
      bin: ['bin']
      dist: ['dist']

    browserify: 
      dev: 
        options:
          preBundleCB: (b)->
            b.transform(coffeeify)
            b.transform(stringify({extensions: ['.hbs', '.html', '.tpl', '.txt']}))
        expand: true
        flatten: true
        src: ['src/js/main.coffee']
        dest: 'bin/js'
        ext: '.js'
      test: 
        options:
          preBundleCB: (b)->
            b.transform(coffeeify)
            b.transform(stringify({extensions: ['.hbs', '.html', '.tpl', '.txt']}))
        expand: true
        flatten: true
        src: ['example/example.coffee']
        dest: 'bin/js'
        ext: '.js'

    watch:
      compile:
        options:
          livereload: true
        files: [
          'test/**/*.coffee', 
          'src/**/*.coffee', 
          'src/**/*.less', 
          'src/**/*.html', 
          'example/**/*.coffee', 
          'example/**/*.less', 
          'example/**/*.html', 
          'index.html'
        ]
        tasks: ['browserify', 'less']

    less:    
      dev:
        files:
          'bin/css/main.css': ['src/css/main.less']
          'bin/css/example.css': ['example/**/*.less']


    uglify:
      build:
        files:
          'dist/LA.min.js': ['bin/js/main.js']

    cssmin:    
      build:
        files:
          'dist/LA.min.css': ['bin/css/main.css']

  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'

  grunt.registerTask 'default', ->
    grunt.task.run [
      'connect'
      'clean:bin'
      'browserify'
      'less'
      'watch'
    ]

  grunt.registerTask 'build', [
    'clean:bin'
    'clean:dist'
    'browserify' 
    'less' 
    'uglify'
    'cssmin'
  ]
