'use strict';

var csso = require('gulp-csso');
var gulp = require('gulp');
var livereload = require('gulp-livereload');
var mainBowerFiles = require('main-bower-files');
var pixrem = require('gulp-pixrem');
var plumber = require('gulp-plumber');
var preen = require('preen');
var prefix = require('gulp-autoprefixer');
var sass = require('gulp-sass');

// Helper returns parent dirs for files.
var mainFileDirs = function(files) {
  return files.map(function(file) {
    var pathComponents = file.split('/');
    pathComponents.splice(pathComponents.length - 1, 1);
    return pathComponents.join('/');
  });
};

//////////////////////////////
// Begin Gulp Tasks
//////////////////////////////

// SASS
gulp.task('sass', function () {
  gulp.src('./sass/*.scss')
    .pipe(plumber())
    .pipe(sass({
      // SASS import needs main dir, not the main file itself.
      includePaths: mainFileDirs(mainBowerFiles({includeDev: true}))
    }))
    .pipe(prefix({
      browsers: ['last 10 versions'],
      cascade: false
    }))
    .pipe(csso())
    .pipe(pixrem('16px'))
    .pipe(gulp.dest('./css'))
    .pipe(livereload());
});

// Cleaner
gulp.task('preen', function(cb) {
  preen.preen({}, cb);
});

// Watch
gulp.task('watch', function () {
  livereload.listen();
  gulp.watch('sass/**/*.scss', ['sass']);
});

//////////////////////////////
// Server Tasks
//////////////////////////////
gulp.task('default', ['watch', 'preen']);
