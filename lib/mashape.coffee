{MASHAPE_SECRET} = process.env
restify = require 'restify'

mashapeCheck = (req, res, next) ->
  if (req.headers['X-Mashape-Proxy-Secret'] isnt MASHAPE_SECRET)
    msg = 'requests must be authorized by mashape.com'
    err = new restify.InvalidHeaderError msg
    return next err

  next()

module.exports = mashapeCheck
