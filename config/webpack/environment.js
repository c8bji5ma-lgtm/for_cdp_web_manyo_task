const { environment } = require('@rails/webpacker')

// Node.js 24で問題になる可能性がある圧縮プラグインが
// 存在する場合だけ削除する
if (environment.plugins.keys().includes('Compression')) {
  environment.plugins.delete('Compression')
}

if (environment.plugins.keys().includes('Compression Brotli')) {
  environment.plugins.delete('Compression Brotli')
}

module.exports = environment