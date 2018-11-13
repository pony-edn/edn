# PONY-EDN 

pony-edn is a Pony implementation of the EDN (extensible data notation) format.

This library is heavily influenced by the [go-edn library](https://github.com/go-edn/edn).

## Status

[![CircleCI](https://circleci.com/gh/pony-edn/edn.svg?style=svg)](https://circleci.com/gh/pony-edn/edn)

In Development

## Installation

* Install [pony-stable](https://github.com/ponylang/pony-stable)
* Update your `bundle.json`

```json
{ 
  "type": "github",
  "repo": "pony-edn/edn"
}
```

* `stable fetch` to fetch your dependencies
* `use "edn"` to include this package
* `stable env ponyc` to compile your application