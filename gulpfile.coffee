#CONFIGURATION
path =
    css: './'
    scss: 'scss/'
    img: 'img/'
    js: 'js/'
    images: 'images/'
#REQUIRE
gulp = require('gulp')
browserSync = require('browser-sync')
cssMinify = require('gulp-clean-css')
$ = require('gulp-load-plugins')()

#TASK

gulp.task 'sass', ->
    gulp.src "#{path.scss}*.scss"
    .pipe $.plumber(errorHandler: (err) ->
        console.log err
        @emit "end"
        )
    .pipe $.sass()
    .pipe $.autoprefixer
        browsers: ["ie >= 9", "ie_mob >= 10", "ff >= 30", "chrome >= 34", "safari >= 7",  "opera >= 23", "ios >= 7", "android >= 4.4", "bb >= 10"]
    .pipe cssMinify {compatibility: 'ie8'}
    .pipe gulp.dest path.css
    .pipe $.size()
    .pipe browserSync.reload(stream: true)


gulp.task 'copyPictures', ->
    dest = path.img + "pictures"
    gulp.src path.img + "pictures/@2x/*.jpg"
    .pipe $.changed dest
    .pipe $.imageResize {width: '50%', height: '50%'; imageMagick: true;}
    .pipe gulp.dest dest

gulp.task 'compressRetina', ['copyPictures'], ->
    opts = {optimizationLevel: 5, progressive: true, interlace: true;}
    pictures = gulp.src "#{path.img}pictures/@2x/*.jpg"
    pictures.pipe($.imagemin(opts))
    .pipe $.rename {suffix: "@2x"}
    .pipe gulp.dest path.images


  gulp.task 'compressNonRetina', ['compressRetina'], ->
    opts = {optimizationLevel: 5, progressive: true, interlace: true;}
    pictures = gulp.src "#{path.img}pictures/*.jpg"
    pictures.pipe($.imagemin(opts))
    .pipe gulp.dest path.images


gulp.task 'compress', ->
    gulp.src "#{path.js}app/*.js"
    .pipe $.plumber(errorHandler: (err) ->
        console.log err
        @emit "end"
        )
    .pipe $.uglify()
    .pipe gulp.dest "#{path.js}"
    .pipe browserSync.reload(stream: true)

gulp.task 'default', ->
    browserSync
        notify: false
        proxy: 'localhost'
#WATCH
    gulp.watch ['**/*.html'], browserSync.reload
    gulp.watch ['**/*.php'], browserSync.reload
    gulp.watch "#{path.img}pictures/@2x/*.jpg", ['compressNonRetina']
    gulp.watch "#{path.scss}**/*.scss", ['sass']
    gulp.watch "#{path.js}**/*.js", ['compress']
