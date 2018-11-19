use "ponytest"
use "collections"

use ".."

class iso _TestParseBasic is UnitTest
  """
  Test EDN basic parsing, eg allowing whitespace.
  """
  fun name(): String => "ESN/parse.basic"

  fun apply(h: TestHelper) ? =>
    let doc: EdnDoc = EdnDoc

    doc.parse("true")?
    h.assert_eq[Bool](true, doc.data as Bool)

    doc.parse(" true   ")?
    h.assert_eq[Bool](true, doc.data as Bool)

    h.assert_error({() ? => EdnDoc.parse("")? })
    h.assert_error({() ? => EdnDoc.parse("   ")? })
    h.assert_error({() ? => EdnDoc.parse("true true")? })

class iso _TestParseKeyword is UnitTest
  """
  Test EDN parsing of keywords.
  """
  fun name(): String => "EDN/parse.keyword"

  fun apply(h: TestHelper) ? =>
    let doc: EdnDoc = EdnDoc

    doc.parse("true")?
    h.assert_eq[Bool](true, doc.data as Bool)

    doc.parse("false")?
    h.assert_eq[Bool](false, doc.data as Bool)

    doc.parse("nil")?
    h.assert_eq[None](None, doc.data as None)

    h.assert_error({() ? => EdnDoc.parse("tru e")? })
    h.assert_error({() ? => EdnDoc.parse("truw")? })
    h.assert_error({() ? => EdnDoc.parse("truez")? })
    h.assert_error({() ? => EdnDoc.parse("TRUE")? })

class iso _TestParseInt is UnitTest
  """
  Test EDN parsing of ints.
  """
  fun name(): String => "EDN/parse.int"

  fun apply(h: TestHelper) ? =>
    let doc: EdnDoc = EdnDoc

    doc.parse("0")?
    h.assert_eq[I64](0, doc.data as I64)

    doc.parse("13")?
    h.assert_eq[I64](13, doc.data as I64)

    doc.parse("-13")?
    h.assert_eq[I64](-13, doc.data as I64)

    doc.parse("8223372036854775808")?
    h.assert_eq[I64](8223372036854775808, doc.data as I64)

    doc.parse("-5N")?
    h.assert_eq[I64](-5, doc.data as I64)

    doc.parse("-0N")?
    h.assert_eq[I64](0, doc.data as I64)

    h.assert_error({() ? => EdnDoc.parse("0x4")? })
    h.assert_error({() ? => EdnDoc.parse("+1")? })
    h.assert_error({() ? => EdnDoc.parse("1e")? })

class iso _TestParseFloat is UnitTest
  """
  Test EDN parsing of floats.
  """
  fun name(): String => "EDN/parse.float"

  fun apply(h: TestHelper) ? =>
    let doc: EdnDoc = EdnDoc

    doc.parse("0.0")?
    h.assert_eq[F64](0.0, doc.data as F64)

    doc.parse("1.5")?
    h.assert_eq[F64](1.5, doc.data as F64)

    doc.parse("-1.125")?
    h.assert_eq[F64](-1.125, doc.data as F64)

    doc.parse("1e3")?
    h.assert_eq[F64](1000, doc.data as F64)

    doc.parse("1e+3")?
    h.assert_eq[F64](1000, doc.data as F64)

    doc.parse("1e-3")?
    h.assert_eq[F64](0.001, doc.data as F64)

    doc.parse("1.23e3")?
    h.assert_eq[F64](1230, doc.data as F64)

    h.assert_error({() ? => EdnDoc.parse("1.")? })
    h.assert_error({() ? => EdnDoc.parse("1.-3")? })

class iso _TestParseString is UnitTest
  """
  Test EDN parsing of strings.
  """
  fun name(): String => "EDN/parse.string"

  fun apply(h: TestHelper) ? =>
    let doc: EdnDoc = EdnDoc

    doc.parse(""""Foo"""")?
    h.assert_eq[String]("Foo", doc.data as String)

    doc.parse(""" "Foo\tbar" """)?
    h.assert_eq[String]("Foo\tbar", doc.data as String)

    doc.parse(""" "Foo\"bar" """)?
    h.assert_eq[String]("""Foo"bar""", doc.data as String)

    doc.parse(""" "Foo\\bar" """)?
    h.assert_eq[String]("""Foo\bar""", doc.data as String)

    doc.parse(""" "Foo\u0020bar" """)?
    h.assert_eq[String]("""Foo bar""", doc.data as String)

    doc.parse(""" "Foo\u004Fbar" """)?
    h.assert_eq[String]("""FooObar""", doc.data as String)

    doc.parse(""" "Foo\u004fbar" """)?
    h.assert_eq[String]("""FooObar""", doc.data as String)

    doc.parse(""" "Foo\uD834\uDD1Ebar" """)?
    h.assert_eq[String]("Foo\U01D11Ebar", doc.data as String)

    h.assert_error({() ? => EdnDoc.parse(""" "Foo """)? })
    h.assert_error({() ? => EdnDoc.parse(""" "Foo\z" """)? })
    h.assert_error({() ? => EdnDoc.parse(""" "\u" """)? })
    h.assert_error({() ? => EdnDoc.parse(""" "\u37" """)? })
    h.assert_error({() ? => EdnDoc.parse(""" "\u037g" """)? })
    h.assert_error({() ? => EdnDoc.parse(""" "\uD834" """)? })
    h.assert_error({() ? => EdnDoc.parse(""" "\uDD1E" """)? })

class iso _TestParseArray is UnitTest
  """
  Test EDN parsing of arrays.
  """
  fun name(): String => "EDN/parse.array"

  fun apply(h: TestHelper) ? =>
    let doc: EdnDoc = EdnDoc

    doc.parse("[]")?
    h.assert_eq[USize](0, (doc.data as EdnArray).data.size())

    doc.parse("[ ]")?
    h.assert_eq[USize](0, (doc.data as EdnArray).data.size())

    doc.parse("[true]")?
    h.assert_eq[USize](1, (doc.data as EdnArray).data.size())
    h.assert_eq[Bool](true, (doc.data as EdnArray).data(0)? as Bool)

    doc.parse("[ true ]")?
    h.assert_eq[USize](1, (doc.data as EdnArray).data.size())
    h.assert_eq[Bool](true, (doc.data as EdnArray).data(0)? as Bool)

    doc.parse("[true, false]")?
    h.assert_eq[USize](2, (doc.data as EdnArray).data.size())
    h.assert_eq[Bool](true, (doc.data as EdnArray).data(0)? as Bool)
    h.assert_eq[Bool](false, (doc.data as EdnArray).data(1)? as Bool)

    doc.parse("[true , 13,nil]")?
    h.assert_eq[USize](3, (doc.data as EdnArray).data.size())
    h.assert_eq[Bool](true, (doc.data as EdnArray).data(0)? as Bool)
    h.assert_eq[I64](13, (doc.data as EdnArray).data(1)? as I64)
    h.assert_eq[None](None, (doc.data as EdnArray).data(2)? as None)

    doc.parse("[true, [52, nil]]")?
    h.assert_eq[USize](2, (doc.data as EdnArray).data.size())
    h.assert_eq[Bool](true, (doc.data as EdnArray).data(0)? as Bool)
    h.assert_eq[USize](2,
      ((doc.data as EdnArray).data(1)? as EdnArray).data.size())
    h.assert_eq[I64](52,
      ((doc.data as EdnArray).data(1)? as EdnArray).data(0)? as I64)
    h.assert_eq[None](None,
      ((doc.data as EdnArray).data(1)? as EdnArray).data(1)? as None)

    h.assert_error({() ? => EdnDoc.parse("[,]")? })
    h.assert_error({() ? => EdnDoc.parse("[true,]")? })
    h.assert_error({() ? => EdnDoc.parse("[,true]")? })
    h.assert_error({() ? => EdnDoc.parse("[")? })
    h.assert_error({() ? => EdnDoc.parse("[true")? })
    h.assert_error({() ? => EdnDoc.parse("[true,")? })

class iso _TestParseObject is UnitTest
  """
  Test EDN parsing of objects.
  """
  fun name(): String => "EDN/parse.object"

  fun apply(h: TestHelper) ? =>
    let doc: EdnDoc = EdnDoc

    doc.parse("{}")?
    h.assert_eq[USize](0, (doc.data as EdnObject).data.size())

    doc.parse("{ }")?
    h.assert_eq[USize](0, (doc.data as EdnObject).data.size())

    doc.parse("""{:foo true}""")?
    h.assert_eq[USize](1, (doc.data as EdnObject).data.size())
    h.assert_eq[Bool](true, (doc.data as EdnObject).data("foo")? as Bool)

    doc.parse("""{ :foo "true" }""")?
    h.assert_eq[USize](1, (doc.data as EdnObject).data.size())
    h.assert_eq[String]("true", (doc.data as EdnObject).data("foo")? as String)

    doc.parse("""{:a true :b false}""")?
    h.assert_eq[USize](2, (doc.data as EdnObject).data.size())
    h.assert_eq[Bool](true, (doc.data as EdnObject).data("a")? as Bool)
    h.assert_eq[Bool](false, (doc.data as EdnObject).data("b")? as Bool)

    doc.parse("""{:a true, :b false}""")?
    h.assert_eq[USize](2, (doc.data as EdnObject).data.size())
    h.assert_eq[Bool](true, (doc.data as EdnObject).data("a")? as Bool)
    h.assert_eq[Bool](false, (doc.data as EdnObject).data("b")? as Bool)

    doc.parse("""{:a true , :b 13,:c nil}""")?
    h.assert_eq[USize](3, (doc.data as EdnObject).data.size())
    h.assert_eq[Bool](true, (doc.data as EdnObject).data("a")? as Bool)
    h.assert_eq[I64](13, (doc.data as EdnObject).data("b")? as I64)
    h.assert_eq[None](None, (doc.data as EdnObject).data("c")? as None)

    doc.parse("""{:a true :b {:c 52 :d nil}}""")?
    h.assert_eq[USize](2, (doc.data as EdnObject).data.size())
    h.assert_eq[Bool](true, (doc.data as EdnObject).data("a")? as Bool)
    h.assert_eq[USize](2,
      ((doc.data as EdnObject).data("b")? as EdnObject).data.size())
    h.assert_eq[I64](52,
      ((doc.data as EdnObject).data("b")? as EdnObject).data("c")? as I64)
    h.assert_eq[None](None,
      ((doc.data as EdnObject).data("b")? as EdnObject).data("d")? as None)

    h.assert_error({() ? => EdnDoc.parse("""{,}""")? })
    h.assert_error({() ? => EdnDoc.parse("""{:a true,}""")? })
    h.assert_error({() ? => EdnDoc.parse("""{,:a true}""")? })
    h.assert_error({() ? => EdnDoc.parse("""{""")? })
    h.assert_error({() ? => EdnDoc.parse("""{:a """)? })
    h.assert_error({() ? => EdnDoc.parse("""{:a true""")? })
    h.assert_error({() ? => EdnDoc.parse("""{:a true,""")? })
    h.assert_error({() ? => EdnDoc.parse("""{:true}""")? })

class iso _TestParseRFC1 is UnitTest
  """
  Test EDN parsing of first example from RFC7159.
  """
  fun name(): String => "EDN/parse.rfc1"

  fun apply(h: TestHelper) ? =>
    let src =
      """
      {
        :image {
          :width     800
          :height    600
          :title     "View from 15th Floor"
          :thumbnail {
            :url       "http://www.example.com/image/481989943"
            :height    125
            :width     100
          }
          :animated  false
          :ids [116 943 234 38793]
        }
      }
      """

    let doc: EdnDoc = EdnDoc
    
    doc.parse(src)?

    let obj1 = doc.data as EdnObject

    h.assert_eq[USize](1, obj1.data.size())

    let obj2 = obj1.data("image")? as EdnObject

    h.assert_eq[USize](6, obj2.data.size())
    h.assert_eq[I64](800, obj2.data("width")? as I64)
    h.assert_eq[I64](600, obj2.data("height")? as I64)
    h.assert_eq[String]("View from 15th Floor", obj2.data("title")? as String)
    h.assert_eq[Bool](false, obj2.data("animated")? as Bool)

    let obj3 = obj2.data("thumbnail")? as EdnObject

    h.assert_eq[USize](3, obj3.data.size())
    h.assert_eq[I64](100, obj3.data("width")? as I64)
    h.assert_eq[I64](125, obj3.data("height")? as I64)
    h.assert_eq[String]("http://www.example.com/image/481989943",
      obj3.data("url")? as String)

    let array = obj2.data("ids")? as EdnArray

    h.assert_eq[USize](4, array.data.size())
    h.assert_eq[I64](116, array.data(0)? as I64)
    h.assert_eq[I64](943, array.data(1)? as I64)
    h.assert_eq[I64](234, array.data(2)? as I64)
    h.assert_eq[I64](38793, array.data(3)? as I64)

class iso _TestParseRFC2 is UnitTest
  """
  Test EDN parsing of second example from RFC7159.
  """
  fun name(): String => "EDN/parse.rfc2"

  fun apply(h: TestHelper) ? =>
    let src =
      """
      [
        {
          :precision "zip"
          :latitude  37.7668
          :longitude -122.3959
          :address   ""
          :city      "SAN FRANCISCO"
          :state     "CA"
          :zip       "94107"
          :country   "US"
        }
        {
          :precision "zip"
          :latitude  37.371991
          :longitude -122.026020
          :address   ""
          :city      "SUNNYVALE"
          :state     "CA"
          :zip       "94085"
          :country   "US"
        }
      ]
      """

    let doc: EdnDoc = EdnDoc

    doc.parse(src)?

    let array = doc.data as EdnArray

    h.assert_eq[USize](2, array.data.size())

    let obj1 = array.data(0)? as EdnObject

    h.assert_eq[USize](8, obj1.data.size())
    h.assert_eq[String]("zip", obj1.data("precision")? as String)
    h.assert_true(((obj1.data("latitude")? as F64) - 37.7668).abs() < 0.001)
    h.assert_true(((obj1.data("longitude")? as F64) + 122.3959).abs() < 0.001)
    h.assert_eq[String]("", obj1.data("address")? as String)
    h.assert_eq[String]("SAN FRANCISCO", obj1.data("city")? as String)
    h.assert_eq[String]("CA", obj1.data("state")? as String)
    h.assert_eq[String]("94107", obj1.data("zip")? as String)
    h.assert_eq[String]("US", obj1.data("country")? as String)

    let obj2 = array.data(1)? as EdnObject

    h.assert_eq[USize](8, obj2.data.size())
    h.assert_eq[String]("zip", obj2.data("precision")? as String)
    h.assert_true(((obj2.data("latitude")? as F64) - 37.371991).abs() < 0.001)
    h.assert_true(((obj2.data("longitude")? as F64) + 122.026020).abs() < 0.001)
    h.assert_eq[String]("", obj2.data("address")? as String)
    h.assert_eq[String]("SUNNYVALE", obj2.data("city")? as String)
    h.assert_eq[String]("CA", obj2.data("state")? as String)
    h.assert_eq[String]("94085", obj2.data("zip")? as String)
    h.assert_eq[String]("US", obj2.data("country")? as String)

class iso _TestPrintKeyword is UnitTest
  """
  Test EDN printing of keywords.
  """
  fun name(): String => "EDN/print.keyword"

  fun apply(h: TestHelper) =>
    let doc: EdnDoc = EdnDoc

    doc.data = true
    h.assert_eq[String]("true", doc.string())

    doc.data = false
    h.assert_eq[String]("false", doc.string())

    doc.data = None
    h.assert_eq[String]("nil", doc.string())

class iso _TestPrintNumber is UnitTest
  """
  Test EDN printing of numbers.
  """
  fun name(): String => "EDN/print.number"

  fun apply(h: TestHelper) =>
    let doc: EdnDoc = EdnDoc

    doc.data = I64(0)
    h.assert_eq[String]("0", doc.string())

    doc.data = I64(13)
    h.assert_eq[String]("13", doc.string())

    doc.data = I64(-13)
    h.assert_eq[String]("-13", doc.string())

    doc.data = F64(0)
    h.assert_eq[String]("0.0", doc.string())

    doc.data = F64(1.5)
    h.assert_eq[String]("1.5", doc.string())

    doc.data = F64(-1.5)
    h.assert_eq[String]("-1.5", doc.string())

    // We don't test exponent formatted output because it can be slightly
    // different on different platforms

class iso _TestPrintString is UnitTest
  """
  Test EDN printing of strings.
  """
  fun name(): String => "EDN/print.string"

  fun apply(h: TestHelper) =>
    let doc: EdnDoc = EdnDoc

    doc.data = "Foo"
    h.assert_eq[String](""""Foo"""", doc.string())

    doc.data = "Foo\tbar"
    h.assert_eq[String](""""Foo\tbar"""", doc.string())

    doc.data = "Foo\"bar"
    h.assert_eq[String](""""Foo\"bar"""", doc.string())

    doc.data = "Foo\\bar"
    h.assert_eq[String](""""Foo\\bar"""", doc.string())

    doc.data = "Foo\abar"
    h.assert_eq[String](""""Foo\u0007bar"""", doc.string())

    doc.data = "Foo\u1000bar"
    h.assert_eq[String](""""Foo\u1000bar"""", doc.string())

    doc.data = "Foo\U01D11Ebar"
    h.assert_eq[String](""""Foo\uD834\uDD1Ebar"""", doc.string())

class iso _TestPrintArray is UnitTest
  """
  Test EDN printing of arrays.
  """
  fun name(): String => "EDN/print.array"

  fun apply(h: TestHelper) =>
    let doc: EdnDoc = EdnDoc
    let array: EdnArray = EdnArray

    doc.data = array
    h.assert_eq[String]("[]", doc.string("  ", true))

    array.data.clear()
    array.data.push(true)
    h.assert_eq[String]("[\n  true\n]", doc.string("  ", true))

    array.data.clear()
    array.data.push(true)
    array.data.push(false)
    h.assert_eq[String]("[\n  true\n  false\n]", doc.string("  ", true))

    array.data.clear()
    array.data.push(true)
    array.data.push(I64(13))
    array.data.push(None)
    h.assert_eq[String]("[\n  true\n  13\n  nil\n]", doc.string("  ", true))

    array.data.clear()
    array.data.push(true)
    var nested: EdnArray = EdnArray
    nested.data.push(I64(52))
    nested.data.push(None)
    array.data.push(nested)
    h.assert_eq[String]("[\n  true\n  [\n    52\n    nil\n  ]\n]",
      doc.string("  ", true))

class iso _TestNoPrettyPrintArray is UnitTest
  """
  Test EDN none-pretty printing of arrays.
  """
  fun name(): String => "EDN/nopprint.array"

  fun apply(h: TestHelper) =>
    let doc: EdnDoc = EdnDoc
    let array: EdnArray = EdnArray

    doc.data = array
    h.assert_eq[String]("[]", doc.string())

    array.data.clear()
    array.data.push(true)
    h.assert_eq[String]("[true]", doc.string())

    array.data.clear()
    array.data.push(true)
    array.data.push(false)
    h.assert_eq[String]("[true false]", doc.string())

    array.data.clear()
    array.data.push(true)
    array.data.push(I64(13))
    array.data.push(None)
    h.assert_eq[String]("[true 13 nil]", doc.string())

    array.data.clear()
    array.data.push(true)
    var nested: EdnArray = EdnArray
    nested.data.push(I64(52))
    nested.data.push(None)
    array.data.push(nested)
    h.assert_eq[String]("[true [52 nil]]",
      doc.string())

class iso _TestPrintObject is UnitTest
  """
  Test EDN printing of objects.
  """
  fun name(): String => "EDN/print.object"

  fun apply(h: TestHelper) =>
    let doc: EdnDoc = EdnDoc
    let obj: EdnObject = EdnObject

    doc.data = obj
    h.assert_eq[String]("{}", doc.string("  ", true))

    obj.data.clear()
    obj.data("foo") = true
    h.assert_eq[String]("{\n  :foo true\n}", doc.string("  ", true))

    obj.data.clear()
    obj.data("a") = true
    obj.data("b") = I64(3)
    let s = doc.string("  ", true)
    h.assert_true((s == "{\n  :a true\n  :b 3\n}") or
      (s == "{\n  :b false\n  :a true\n}"))

    // We don't test with more fields in the object because we don't know what
    // order they will be printed in

class iso _TestNoPrettyPrintObject is UnitTest
  """
  Test EDN none-pretty printing of objects.
  """
  fun name(): String => "EDN/nopprint.object"

  fun apply(h: TestHelper) =>
    let doc: EdnDoc = EdnDoc
    let obj: EdnObject = EdnObject

    doc.data = obj
    h.assert_eq[String]("{}", doc.string())

    obj.data.clear()
    obj.data("foo") = true
    h.assert_eq[String]("{:foo true}", doc.string())

    obj.data.clear()
    obj.data("a") = true
    obj.data("b") = I64(3)
    let s = doc.string()
    h.assert_true((s == "{:a true :b 3}") or
      (s == "{:b 3 :a true}"))

    // We don't test with more fields in the object because we don't know what
    // order they will be printed in

class iso _TestParsePrint is UnitTest
  """
  Test EDN parsing a complex example and then reprinting it.
  """
  fun name(): String => "EDN/parseprint"

  fun apply(h: TestHelper) ? =>
    // Note that this example contains no objects with more than 1 member,
    // because the order the fields are printed is unpredictable
    let src =
      """
      [
        {
          :precision "zip"
        }
        {
          :data [
            {}
            "Really?"
            "yes"
            true
            4
            12.3
          ]
        }
        47
        {
          :foo {
            :bar [
              {
                :aardvark nil
              }
              false
            ]
          }
        }
      ]"""

    let doc: EdnDoc = EdnDoc
    doc.parse(src)?
    let printed = doc.string("  ", true)

    // TODO: Sort out line endings on different platforms. For now normalise
    // before comparing
    let actual: String ref = printed.clone()
    actual.remove("\r")

    let expect: String ref = src.clone()
    expect.remove("\r")

    h.assert_eq[String ref](expect, actual)