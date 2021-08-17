const { environment } = require('@rails/webpacker')

// https://webpack.js.org/plugins/provide-plugin/

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    jquery: 'jquery/src/jquery',
    Popper: 'popper.js/dist/popper',
  })
)

module.exports = environment
