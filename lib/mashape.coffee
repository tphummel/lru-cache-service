{MASHAPE_SECRET} = process.env
restify = require 'restify'

mashapeCheck = (req, res, next) ->
  console.log 'request headers: ', req.headers
  console.log 'mashape secret: ', MASHAPE_SECRET
  console.log "req.route: ", req.route

  return next() unless req.route?.path?.match /\/api\/.*/

  if (req.headers['x-mashape-proxy-secret'] isnt MASHAPE_SECRET)
    msg = 'requests must be authorized by mashape.com'
    err = new restify.InvalidHeaderError msg
    return next err

  next()

module.exports = mashapeCheck
