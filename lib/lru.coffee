lru     = require 'lru-cache'

maxSizeInBytes = 209715200 # 200MB

cache = lru
  max: maxSizeInBytes
  length: (n) -> n.length
  dispose: (key, n) -> console.log "[dispose] #{key}"

module.exports = cache
