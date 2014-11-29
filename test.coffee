
_ = require 'lodash'
assert = require 'assert'
bignum = require 'browserify-bignum'

sourceFile = process.env.SEEDGEN_FILE || './seedgen.js'
console.info "Testing against #{sourceFile}"
seedgen = require sourceFile

describe 'basics', ->
  it 'is a function', ->
    assert.ok typeof seedgen == 'function'

  it 'throws an error if no arguments are specified', ->
    assert.throws ->
      seedgen()

  it 'returns a function', ->
    run = seedgen {}
    assert.ok typeof run == 'function'

  it 'returns an empty object back for empty parameter object', ->
    run = seedgen {}
    result = run 'seed'
    assert.ok _.isObject(result)
    assert.ok _.isEmpty(result)

  it 'allows running multiple keys on a seed', ->
    run = seedgen {}
    run 'corn'
    run 'seed'

  it 'exposes numCombinations on function as a bignum', ->
    run = seedgen x: 12, y: 3
    assert.ok run.numCombinations.equals(36)

  it 'exposes inOrder on function', ->
    run = seedgen x: 12, y: 3
    assert.ok run.inOrder

  it 'gives an error when given a non-string key', ->
    assert.ok seedgen({a: 2})(12) instanceof Error

  it 'gives an error when no arguments are specified', ->
    assert.ok seedgen({a: 2})() instanceof Error


describe 'inOrder', ->
  it 'gives an error when given a non-number key', ->
    assert.ok seedgen({a: 2}).inOrder('12') instanceof Error

  it 'gives an error when no arguments are specified', ->
    assert.ok seedgen({a: 2}).inOrder() instanceof Error

  it 'accepts a native number', ->
    source = x: 3, y: 4, z: 7
    run = seedgen source
    result = run.inOrder 12
    assert.deepEqual result, {x: 0, y: 1, z: 5}

  it 'accepts a bignum', ->
    source = x: 3, y: 4, z: 7
    run = seedgen source
    result = run.inOrder bignum(12)
    assert.deepEqual result, {x: 0, y: 1, z: 5}

  it 'gives the only possible number for params with 1 possible option', ->
    run = seedgen {one: 1}
    result = run.inOrder 0
    assert.deepEqual result, {one: 0}

  it 'gives correct in-order-value for every index', ->
    source = x: 3, y: 4, z: 7
    run = seedgen source

    for x in [0...source.x]
      for y in [0...source.y]
        for z in [0...source.z]
          i = (x * source.y * source.z) + (y * source.z) + z
          result = run.inOrder i, inOrder: true
          assert.deepEqual result, {x, y, z}

    assert.equal i, 3*4*7 - 1 # make sure we tested all cases

  it 'wraps around when key exceeds numCombinations', ->
    run = seedgen x: 3, y: 4, z: 7
    result = run.inOrder 3*4*7 + 5
    assert.deepEqual result, {x: 0, y: 0, z: 5}

describe 'arbitrary values', ->
  # We want these to give the same values through development
  # if one of these tests fails we should do a major version bump

  it 'gives correct value for this key', ->
    assert.deepEqual seedgen(x: 14, y: 25, z: 84)('sdfg'), {x: 8, y: 4, z: 80}

  it 'gives correct value for that key', ->
    assert.deepEqual seedgen(x: 14, y: 25, z: 84)('jndssjndfd'), {x: 10, y: 16, z: 58}

  it 'gives correct value for the other key', ->
    assert.deepEqual seedgen(w: 95, x: 776, y: 23, z: 3)('kmsddfj'), {w: 82, x: 631, y: 5, z: 0}

  it 'gives correct value for Annie are you o-key, will you tell us, that youre o-key', ->
    assert.deepEqual seedgen(z: 734)('smooth'), {z: 279}

describe 'large key', ->
  it 'handles a huge key', ->
    run = seedgen {x: 14, y: 25, z: 84}
    key = 'Node.js is an open source, cross-platform runtime environment for server-side and networking applications. Node.js applications are written in JavaScript, and can be run within the Node.js runtime on OS X, Microsoft Windows, Linux and FreeBSD. Node.js provides an event-driven architecture and a non-blocking I/O API that optimizes an applications throughput and scalability. These technologies are commonly used for real-time applications. Node.js uses the Google V8 JavaScript engine to execute code, and a large percentage of the basic modules are written in JavaScript. Node.js contains a built-in library to allow applications to act as a Web server without software such as Apache HTTP Server or IIS. Node.js is gaining adoption as a server-side platform and is used by Groupon, SAP, LinkedIn, Microsoft, Yahoo!, Walmart, Rakuten and PayPal.'
    result = run key
    assert.deepEqual result, {x: 3, y: 11, z: 45}
