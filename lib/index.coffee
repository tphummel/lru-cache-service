process.env.NODE_ENV ?= 'development'

{NODE_ENV, MASHAPE_SECRET} = process.env
isProd = NODE_ENV is 'production'

process.exit 1 if isProd and !MASHAPE_SECRET

port = process.env.PORT or '3000'

url         = require 'url'
restify     = require 'restify'
logger      = require './logger'
pkg         = require '../package.json'
cacheApi    = require './api/cache'

module.exports = server = restify.createServer
  name: 'lru-cache-service'
  version: '0.0.0'

server.use restify.bodyParser()
server.use (restify.acceptParser server.acceptable)
server.use restify.gzipResponse()

server.on 'after', logger

server.get '/api/health', (req, res, next) ->
  res.send 200,
    status: 'OK'
    ts: req._time
    service: server.name
    package: pkg.version

  next()

server.post '/api/cache', cacheApi.create
server.get '/api/cache/:key', cacheApi.find

server.listen port, ->
  console.log "#{server.name} listening on port #{port}"