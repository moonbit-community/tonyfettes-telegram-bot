///|
/// Describes a service message about a regular gift that was sent or received.
pub struct GiftInfo {
  gift : Gift
  from : User?
} derive(Show, Eq)

///|
/// Creates a new [GiftInfo].
pub fn GiftInfo::new(gift~ : Gift, from? : User) -> GiftInfo {
  { gift, from }
}

///|
pub impl ToJson for GiftInfo with to_json(self) {
  let object : Map[String, Json] = { "gift": self.gift.to_json() }
  if self.from is Some(v) {
    object["from"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for GiftInfo with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for GiftInfo"))
  }
  let gift : Gift = @json.from_json(object["gift"], path~)
  let from : User? = if object.get("from") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { gift, from }
}
