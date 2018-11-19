"""
# EDN Package

Like the `json` package, the `edn` package provides the [EdnDoc](edn-EdnDoc.md) class both as a container for an EDN
document and as means of parsing from and writing to [String](builtin-String.md).

## EDN Representation

EDN is represented in Pony as the following types:

* object  - [EdnObject](edn-EdnObject.md)
* array   - [EdnArray](edn-EdnArray.md)
* string  - [String](builtin-String.md)
* integer - [I64](builtin-I64.md)
* float   - [F64](builtin-F64.md)
* boolean - [Bool](builtin-Bool.md)
* nil     - [None](builtin-None.md)

The collection types EdnObject and EdnArray can contain any other EDN
structures arbitrarily nested.

[EdnType](edn-EdnType.md) is used to subsume all possible EDN types. It can
also be used to describe everything that can be serialized using this package.

## Parsing EDN

For getting EDN from a String into proper Pony data structures,
[EdnDoc.parse](edn-EdnDoc.md#parse) needs to be used. This will populate the
public field `EdnDoc.data`, which is [None](builtin-None.md), if [parse](edn-EdnDoc.md#parse) has
not been called yet.

Every call to [parse](edn-EdnDoc.md#parse) overwrites the `data` field, so one
EdnDoc instance can be used to parse multiple EDN Strings one by one.

```pony
let doc = EdnDoc
// parsing
doc.parse(\"\"\"{"key":"value", "property: true, "array":[1, 2.5, false]}\"\"\")?

// extracting values from an EDN structure
let edn: EdnObject    = doc.data as EdnObject
let key: String       = edn.data("key")? as String
let property: Boolean = edn.data("property")? as Bool
let array: EdnArray   = edn.data("array")?
let first: I64        = array.data(0)? as I64
let second: F64       = array.data(1)? as F64
let last: Bool        = array.data(2)? as Bool
```

## Writing EDN

EDN is written using the [EdnDoc.string](edn-EdnDoc.md#string) method. This
will serialize the contents of the `data` field to [String](builtin-String.md).

```pony
// building up the EDN data structure
let doc = EdnDoc
let obj = EdnObject
obj.data("key") = "value"
obj.data("property") = true
obj.data("array") = EdnArray.from_array([ as EdnType: I64(1); F64(2.5); false])
doc.data = obj

// writing to String
env.out.print(
  doc.string(where indent="  ", pretty_print=true)
)

```
"""