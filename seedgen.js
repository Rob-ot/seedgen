
var crypto = require('crypto-browserify')
var bignum = require('browserify-bignum')

module.exports = function(source) {
  if (!source) throw new Error('No params specified to seed expander')

  var sourceKeys = Object.keys(source)
  var numSources = sourceKeys.length

  var sourcesByIndex = []
  var numCombinations = bignum(1)
  for (var i = 0; i < numSources; i++) {
    var name = sourceKeys[i]
    var size = source[name]

    numCombinations = numCombinations.mul(size)

    sourcesByIndex[i] = {
      name: name,
      size: size
    }
  }

  var run = function(key, opts) {
    if (typeof key !== 'string') return new Error('Key was not a string')
    if (!opts) opts = {}

    var buffer = crypto.createHash('sha1').update(key).digest()
    var num = bignum.fromBuffer(buffer)
    return run.inOrder(num)
  }

  run.numCombinations = numCombinations

  run.inOrder = function (index) {
    if (!(typeof index === 'number' || typeof index === 'object' && index.mod)) return new Error('Index was not a number')

    var result = {}
    var modded = index.mod ? index.mod(numCombinations) : index % numCombinations

    for (var sourceIndex = 0; sourceIndex < sourcesByIndex.length; sourceIndex++) {
      var source = sourcesByIndex[sourceIndex]
      var name = source.name
      var size = source.size

      var baseNum = modded
      for (var i = sourceIndex + 1; i < numSources; i++) {
        baseNum /= sourcesByIndex[i].size
      }
      baseNum = Math.floor(baseNum)

      var subtractor = 0
      for (var i = 1; i < sourceIndex + 1; i++) {
        var multiplier = result[sourcesByIndex[i - 1].name]
        for (var j = i; j < sourceIndex + 1; j++) {
          multiplier *= sourcesByIndex[j].size
        }

        subtractor += multiplier
      }

      result[name] = baseNum - subtractor
    }

    return result
  }

  return run
}

