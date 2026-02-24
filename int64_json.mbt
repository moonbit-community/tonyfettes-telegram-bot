///|
/// Serialize Int64 as a JSON number (not a string), preserving precision via repr.
fn int64_to_json(value : Int64) -> Json {
  Json::number(value.to_double(), repr=value.to_string())
}

///|
/// Deserialize Int64 from a JSON number.
fn int64_from_json(
  json : Json,
  path : @json.JsonPath,
) -> Int64 raise @json.JsonDecodeError {
  guard json is Number(n, ..) else {
    raise @json.JsonDecodeError((path, "Expected number for Int64"))
  }
  n.to_int64()
}
