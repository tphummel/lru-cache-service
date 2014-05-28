process.env.NODE_ENV ?= 'development'

{NODE_ENV, MASHAPE_SECRET} = process.env
isProd = NODE_ENV is 'production'

process.exit 1 if isProd and !MASHAPE_SECRET

port = process.env.PORT or '3000'

url         = require 'url'
restify     = require 'restify'
logger      = require './logger'
pkg         = require '../package.json'

module.exports = server = restify.createServer
  name: 'service-starter'
  version: '0.0.0'

server.use restify.bodyParser()
server.on 'after', logger

server.get '/health', (req, res, next) ->
  res.send 200,
    status: 'OK'
    ts: req._time
    service: server.name
    package: pkg.version

  next()

server.listen port, ->
  console.log "#{server.name} listening on port #{port}"
