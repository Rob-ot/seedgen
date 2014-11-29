# seedgen

#### Easily generate seeded "random" values

## Example

```javascript
var generate = seedgen({color: 6, rotation: 360})
generate("middlerob")         // { color: 5, rotation: 71 }
generate("rob@middlerob.com") // { color: 2, rotation: 225 }
generate("middlerob")         // { color: 5, rotation: 71 }
```

`seedgen` returns a function that:

1. Gives a `color` of 0 through 5 and a `rotation` of 0 through 359
2. Always gives the same values for the same key/parameters

## Try it out

[Open on jsbin.com](http://jsbin.com/sedokigina/1/edit?js,console)

## Installation

#### Node/Browserify

`npm install seedgen --save`

#### Browser/RequireJS/CommonJS Standalone Package

Dev version [seedgen-standalone.js](seedgen-standalone.js)

Minified [seedgen-standalone.min.js](seedgen-standalone.min.js)

## Development

`npm install` to load dependencies.

#### Run tests

`npm test`

#### Run tests automatically when files change

`npm run testwatch`

#### Build standlone versions

`npm run standalone`
