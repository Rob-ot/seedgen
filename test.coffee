
_ = require 'lodash'
assert = require 'assert'
seed = require './seed-expander'

describe 'sanity', ->
  it 'is a function', ->
    assert.ok typeof seed == 'function'

  it 'returns an error if no arguments are specified', ->
    assert.throws ->
      seed()

  it 'returns a function when given an empty parameter object', ->
    run = seed {}
    assert.ok typeof run == 'function'

  it 'returns gives an empty object back for empty parameter object', ->
    run = seed {}
    result = run 'seed'
    assert.ok _.isObject(result)
    assert.ok _.isEmpty(result)

  describe 'number param', ->
    it 'gives the only possible number for number param with same min and max', ->
      run = seed {one: {type: 'number', min: 1, max: 1}}
      result = run 'seed'
      assert.deepEqual result, {one: 1}



