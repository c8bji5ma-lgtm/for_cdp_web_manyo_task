const { environment } = require('@rails/webpacker')

// Webpacker's optional compression plugins use the MD4 digest that is disabled
// by the OpenSSL version bundled with Node.js 24.
environment.plugins.delete('Compression')
environment.plugins.delete('Compression Brotli')

module.exports = environment