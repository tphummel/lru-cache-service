pkg         = require '../../package.json'
lruCache    = require '../lru'



module.exports = (req, res, next) ->
  # console.log process
  res.send 200,
    status: 'OK'
    ts: req._time
    service: pkg.name
    package: pkg.version
    uptimeSeconds: process.uptime()
    pid: process.pid
    cache:
      bytes: lruCache._length
      items: lruCache._itemCount

  next()
