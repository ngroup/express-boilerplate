gulp = require('gulp')
gutil = require('gulp-util')
coffee = require('gulp-coffee')
minifyCss = require('gulp-minify-css')
nodemon = require('gulp-nodemon')
sass = require('gulp-ruby-sass')
cache = require('gulp-cached')
del = require('del')


paths =
  coffee: './server/**/*.coffee'
  sass: './public/css'
  views: './server/views/**/*'

gulp.task('clean:coffee', (cb) ->
  del([
    './dist/**/*.js'
    '!./dist/public/**'
  ], cb)
)

gulp.task('clean:views', (cb) ->
  del([
    './dist/views'
  ], cb)
)

gulp.task('clean:sass', (cb) ->
  del([
    './dist/public/stylesheets'
  ], cb)
)

gulp.task('coffee', () ->
  gulp.src(paths.coffee)
    .pipe(cache('coffee'))
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./dist'))
)

gulp.task('views', () ->
  gulp.src(paths.views)
    .pipe(cache('views'))
    .pipe(gulp.dest('./dist/views'))
)

gulp.task('sass', () ->
  sass(paths.sass)
    .pipe(cache('coffee'))
    .pipe(minifyCss({compatibility: 'ie8'}))
    .pipe(gulp.dest('./dist/public/stylesheets'))
)

gulp.task('serve', () ->
  nodemon(
    script: './dist/bin/server-dev.js'
    ext: 'js html'
    watch: [
      "./dist"
    ]
    ignore: ['node_modules/']
    env: {'NODE_ENV': 'development'}
  )
)

# Rerun the task when a file changes
gulp.task('watch', () ->
  gulp.watch(paths.sass, ['sass'])
  gulp.watch(paths.views, ['views'])
  gulp.watch(paths.coffee, ['coffee'])
)

gulp.task('clean', ['clean:coffee', 'clean:sass', 'clean:views'])
gulp.task('dev', ['clean'], () ->
  gulp.start('coffee', 'sass', 'views', 'serve', 'watch')
)
