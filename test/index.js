
import basscss from '../src/basscss.css'

var context = require.context('.', true, /.+\.spec\.js$/)
context.keys().forEach(context)
module.exports = context

