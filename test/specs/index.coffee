process.env.NODE_ENV = 'test'
process.env.PORT = 4444

test = require 'tape'
restify = require 'restify'

server = require '../../lib'

jsonClient = restify.createJsonClient
  url: 'http://localhost:4444'
  version: '*'

test '/health', (t) ->
  server = require '../../lib'

  jsonClient = restify.createJsonClient
    url: 'http://localhost:4444'
    version: '*'

  jsonClient.get '/health', (err, req, res, obj) ->
    t.notOk err, 'no err'
    t.equal obj.status, 'OK', 'status OK'
    t.end()

test 'cleanup', (t) ->
  jsonClient.close()
  server.close -> t.end()
