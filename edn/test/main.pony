use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestParseBasic)
    test(_TestParseKeyword)
    test(_TestParseInt)
    test(_TestParseFloat)
    test(_TestParseString)
    test(_TestParseArray)
    test(_TestParseObject)
    test(_TestParseRFC1)
    test(_TestParseRFC2)

    test(_TestPrintKeyword)
    test(_TestPrintNumber)
    test(_TestPrintString)
    test(_TestPrintArray)
    test(_TestPrintObject)

    test(_TestNoPrettyPrintArray)
    test(_TestNoPrettyPrintObject)

    test(_TestParsePrint)