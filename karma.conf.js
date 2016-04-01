
var postcssImport = require('postcss-import')
var postcssCustomMedia = require('postcss-custom-media')
var postcssCustomProperties = require('postcss-custom-properties')
var postcssCalc = require('postcss-calc')

module.exports = function (config) {
  config.set({
    browsers: [
      'Firefox'
    ],

    files: [
      './test/index.js'
    ],

    frameworks: [ 'chai', 'mocha' ],

    plugins: [
      'karma-firefox-launcher',
      'karma-chai',
      'karma-mocha',
      'karma-mocha-reporter',
      'karma-webpack'
    ],

    preprocessors: {
      './test/index.js': [ 'webpack' ]
    },

    reporters: [ 'mocha' ],
    singleRun: true,

    webpack: {
      module: {
        loaders: [
          {
            test: /\.jsx?$/,
            exclude: /node_modules/,
            loader: 'babel-loader'
          },
          {
            test: /\.css$/,
            loader: 'style-loader!css-loader!postcss-loader'
          },
          {
            test: /\.json$/,
            loader: 'json-loader'
          }
        ]
      },
      postcss: function () {
        return [
          postcssImport,
          postcssCustomMedia,
          postcssCustomProperties,
          postcssCalc
        ]
      }
    },


    webpackMiddleware: {
      noInfo: true
    },

    client: {
      mocha: {
        reporter: 'html',
        ui: 'bdd'
      }
    }

  })
}

