use "collections"

type EdnType is (F64 | I64 | Bool | None | String | EdnArray | EdnObject)
  """
  All EDN data types.
  """

class EdnArray
  var data: Array[EdnType]
    """
    The actual array containing EDN structures.
    """

  new create(len: USize = 0) =>
    """
    Create an array with zero elements, but space for len elements.
    """
    data = Array[EdnType](len)

  new from_array(data': Array[EdnType]) =>
    """
    Create an EDN array from an actual array.
    """
    data = data'

  fun string(indent: String = "", pretty_print: Bool = false): String =>
    """
    Generate string representation of this array.
    """
    let buf = _show(recover String(256) end, indent, 0, pretty_print)
    buf.compact()
    buf

  fun _show(
    buf': String iso,
    indent: String = "",
    level: USize,
    pretty: Bool)
    : String iso^
  =>
    """
    Append the string representation of this array to the provided String.
    """
    var buf = consume buf'

    if data.size() == 0 then
      buf.append("[]")
      return buf
    end

    buf.push('[')

    var print_comma = false

    for v in data.values() do
      if not pretty and print_comma then
        buf.push(' ')
      else 
        print_comma = true
      end

      if pretty then
        buf = _EdnPrint._indent(consume buf, indent, level + 1)
      end

      buf = _EdnPrint._string(v, consume buf, indent, level + 1, pretty)
    end

    if pretty then
      buf = _EdnPrint._indent(consume buf, indent, level)
    end

    buf.push(']')
    buf


class EdnObject
  var data: Map[String, EdnType]
    """
    The actual EDN object structure,
    mapping `String` keys to other EDN structures.
    """

  new create(prealloc: USize = 6) =>
    """
    Create a map with space for prealloc elements without triggering a
    resize. Defaults to 6.
    """
    data = Map[String, EdnType](prealloc)

  new from_map(data': Map[String, EdnType]) =>
    """
    Create an EDN object from a map.
    """
    data = data'

  fun string(indent: String = "", pretty_print: Bool = false): String =>
    """
    Generate string representation of this object.
    """
    let buf = _show(recover String(256) end, indent, 0, pretty_print)
    buf.compact()
    buf

  fun _show(buf': String iso, indent: String = "", level: USize, pretty: Bool)
    : String iso^
  =>
    """
    Append the string representation of this object to the provided String.
    """
    var buf = consume buf'

    if data.size() == 0 then
      buf.append("{}")
      return buf
    end

    buf.push('{')

    var print_comma = false

    for (k, v) in data.pairs() do
      if not pretty and print_comma then
        buf.push(' ')
      else 
        print_comma = true
      end

      if pretty then
        buf = _EdnPrint._indent(consume buf, indent, level + 1)
      end

      buf.push(':')
      buf.append(k)

      buf.push(' ')

      buf = _EdnPrint._string(v, consume buf, indent, level + 1, pretty)
    end

    if pretty then
      buf = _EdnPrint._indent(consume buf, indent, level)
    end

    buf.push('}')
    buf