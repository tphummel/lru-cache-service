url = require 'url'

module.exports = (req, res) ->

  urlObj = url.parse req.url

  console.log JSON.stringify
    ts: req._time
    path: req.route.path
    verb: req.route.method
