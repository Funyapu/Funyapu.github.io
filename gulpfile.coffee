gulp = require 'gulp'
postcss = require 'gulp-postcss'
plumber = require 'gulp-plumber'
rename = require 'gulp-rename'
autoprefixer = require 'autoprefixer'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
imagemin = require 'gulp-imagemin'
cache = require 'gulp-cache'
scss = require 'gulp-scss'
slim = require 'gulp-slim'
browserify = require 'browserify'
browserSync = require 'browser-sync'

paths = {
  source: 'source/'
  dest: './'
}

gulp.task 'browser-sync', ->
  browserSync(
    server: 
       baseDir: paths.dest
    
  )

gulp.task 'bs-reload', ->
  browserSync.reload()

gulp.task 'images', ->
  gulp.src paths.source + 'images/**/*'
  .pipe cache(imagemin(
    optimizationLevel: 3
    progressive: true
    interlaced: true
  ))
  .pipe gulp.dest paths.dest + 'images/'
  return

gulp.task 'styles', ->
  gulp.src paths.source + 'stylesheets/**/*.scss'
  .pipe plumber(errorHandler: (error) ->
    console.log error.message
    @emit 'end'
    return
  )
  .pipe scss()
  .pipe postcss([ autoprefixer({ browsers: ['last 2 versions'] }) ])
  .pipe gulp.dest paths.dest + 'stylesheets/'
  .pipe browserSync.reload(stream:true)
  return

gulp.task 'scripts', ->
  gulp.src paths.source + 'javascripts/bundle/*.coffee'
  .pipe plumber(errorHandler: (error) ->
    console.log error.message
    @emit 'end'
    return
  )
  .pipe coffee(bare: true)
  .pipe concat('app.js')
  .pipe gulp.dest(paths.dest + 'javascripts/bundle/')
  #.pipe rename(suffix: '.min')
  #.pipe uglify()
  #.pipe gulp.dest paths.dest + 'javascripts/bundle/'
  .pipe browserSync.reload(stream:true)

gulp.task 'slim', ->
  gulp.src paths.source + 'slim/**/*.slim'
  .pipe slim {
    pretty: true
    options: "attr_list_delims={'(' => ')', '[' => ']'}"
  }
  .pipe gulp.dest paths.dest
  .pipe browserSync.reload(stream:true)

gulp.task 'default',['browser-sync'], ->
  gulp.watch paths.source + 'stylesheets/**/*.scss', [ 'styles' ]
  gulp.watch paths.source + 'slim/**/*.slim', [ 'slim' ]
  gulp.watch paths.source + 'javascripts/bundle/**/*.coffee', [ 'scripts' ]
  return
