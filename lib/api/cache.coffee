url     = require 'url'
path    = require 'path'

uuid    = require 'uuid'
restify = require 'restify'

lruCache = require '../lru'

module.exports =
  create: (req, res, next) ->
    body = req?.body

    requestId = uuid.v4()
    res.header 'Request-Id', requestId
    res.charSet 'utf-8'

    unless body?
      msg = 'POST body is required to write a value to the cache'
      return next new restify.InvalidArgumentError msg

    bodyJson = null
    try
      bodyJson = JSON.stringify body
    catch e
      msg = 'POST body must be valid JSON'
      return next new restify.InvalidArgumentError msg

    cacheKey = uuid.v4()
    lruCache.set cacheKey, bodyJson

    res.header 'Content-Length', bodyJson.length

    location = url.format
      protocol: 'http'
      host: req.header 'host'
      pathname: path.join 'api', 'cache', cacheKey

    # uri of newly created resource
    res.header 'Location', location

    # uri of the representation in the response
    res.header 'Content-Location', location

    res.send 201, body
    next()

  find: (req, res, next) ->
    cacheKey = req.params?.key

    unless cacheKey?
      msg = 'GET /api/cache/:id, :id parameter is required'
      return next new restify.InvalidArgumentError msg

    found = lruCache.get cacheKey

    unless found
      return next new restify.ResourceNotFoundError

    foundObj = null
    try
      foundObj = JSON.parse found
    catch e
      msg = 'GET /api/cache/:id, bad JSON was retrieved from the cache, error parsing'
      return next new restify.InternalError msg

    res.send 200, foundObj
    next()
