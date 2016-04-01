
var fs = require('fs')
var path = require('path')
var assert = require('assert')
var postcss = require('postcss')
var postcssImport = require('postcss-import')
var postcssCustomMedia = require('postcss-custom-media')
var postcssCustomProperties = require('postcss-custom-properties')
var postcssCalc = require('postcss-calc')
var cssstats = require('cssstats')
var mixed = require('css-mixed-properties')

var src = fs.readFileSync(path.join(__dirname, '../src/basscss.css'), 'utf8')

var css
var stats

describe('basscss', function() {

  it('should compile', function(done) {
    assert.doesNotThrow(function() {
      postcss([
        postcssImport,
        postcssCustomMedia,
        postcssCustomProperties,
        postcssCalc
      ])
      .process(src)
      .then(function (result) {
        css = result.css
        done()
      })
    })
  })

  it('should compile to string', function() {
    assert.equal(typeof css, 'string')
  })

  it('should be css', function() {
    assert.doesNotThrow(function() {
      stats = cssstats(css, { safe: false })
    })
  })

  it('should have rules', function() {
    assert(stats.rules.total > 0)
  })

  it('should have declarations', function() {
    assert(stats.declarations.total > 0)
  })

  it('should have properties', function() {
    assert(Object.keys(stats.declarations.properties).length > 0)
  })

  it('should not have a high mix of structure and skin properties', function() {
    var mix = mixed(css)
    var max = 0
    var lineno = 0
    mix.warnings.forEach(function(warning) {
      if (warning.score > max) {
        max = warning.score
        lineno = warning
      }
    })
    assert(max < 7)
  })

})

