process.env.NODE_ENV = 'test'
process.env.PORT = 4444

test = require 'tape'
restify = require 'restify'

server = require '../../lib'
cache = require '../../lib/lru'

jsonClient = restify.createJsonClient
  url: 'http://localhost:4444'
  version: '*'

test '/api/health', (t) ->
  server = require '../../lib'

  jsonClient.get '/api/health', (err, req, res, obj) ->
    t.notOk err, 'no err'
    t.equal obj.status, 'OK', 'status OK'
    t.end()

test '/api/cache', (t) ->

  value = name: "tom"

  jsonClient.post '/api/cache', value, (err, req, res, obj) ->
    t.notOk err, 'no err'
    t.deepEqual obj, value
    t.equal res.statusCode, 201

    expectedHeaders = [
      'request-id'
      'content-length'
      'location'
      'content-location'
      'date'
      'x-created-key'
    ]

    for key in expectedHeaders
      t.ok res.headers[key], "header #{key} should be set on response"

    jsonClient.get res.headers.location, (getErr, getReq, getRes, getObj) ->
      t.notOk getErr, 'no GET err'
      t.deepEqual getObj, value

      t.end()

test 'cleanup', (t) ->
  jsonClient.close()
  server.close -> t.end()
