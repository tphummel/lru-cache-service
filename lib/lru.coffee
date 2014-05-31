lru     = require 'lru-cache'

maxSizeInBytes = 209715200 # 200MB
maxAgeInMs = 48 * 60 * 60 * 1000 # 48 hours

cache = lru
  max: maxSizeInBytes
  # maxAge: maxAgeInMs
  length: (n) -> n.length
  dispose: (key, n) -> console.log "[dispose] #{key}"

module.exports = cache
