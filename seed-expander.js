
module.exports = function (params) {
  // we expect this to run when the app is starting up so throw
  if (!params) throw new Error('No params specified to seed expander')

  var totalVarations = 0
  for (var key in params) {
    if (params.hasOwnProperty(key)) {
      var value = params[key]
      value.varations = value.max - value.min
      totalVarations += value.varations
    }
  }

  return function (seed) {
    var result = {}
    var hashed = seed.toString().split('').reduce(function (hash, char) {
      return hash + char.charCodeAt(0)
    }, 0)

    var variation = hashed % variations

    for (var key in params) {
      if (params.hasOwnProperty(key)) {
        var value = params[key]
        value.varations

      }
    }

    return result
  }
}

