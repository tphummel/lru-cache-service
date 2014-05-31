process.env.NODE_ENV ?= 'development'

{NODE_ENV, MASHAPE_SECRET} = process.env
isProd = NODE_ENV is 'production'

process.exit 1 if isProd and !MASHAPE_SECRET

port = process.env.PORT or '3000'

url         = require 'url'
restify     = require 'restify'
logger      = require './logger'

cache    = require './api/cache'
health   = require './api/health'

module.exports = server = restify.createServer
  name: 'lru-cache-service'
  version: '0.0.0'

server.use restify.bodyParser()
server.use (restify.acceptParser server.acceptable)
server.use restify.gzipResponse()

server.on 'after', logger

server.get '/api/health', health

server.post '/api/cache', cache.create
server.get '/api/cache/:key', cache.find

server.listen port, ->
  console.log "#{server.name} listening on port #{port}"
