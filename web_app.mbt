///|
/// Describes a Web App.
pub struct WebAppInfo {
  url : String
} derive(Show, Eq)

///|
/// Creates a new [WebAppInfo].
pub fn WebAppInfo::new(url~ : String) -> WebAppInfo {
  { url, }
}

///|
pub impl ToJson for WebAppInfo with to_json(self) {
  let object : Map[String, Json] = { "url": self.url.to_json() }
  object.to_json()
}

///|
pub impl @json.FromJson for WebAppInfo with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for WebAppInfo"))
  }
  let url : String = @json.from_json(object["url"], path~)
  { url, }
}

///|
/// Describes an inline message sent by a Web App on behalf of a user.
pub struct SentWebAppMessage {
  inline_message_id : String?
} derive(Show, Eq)

///|
/// Creates a new [SentWebAppMessage].
pub fn SentWebAppMessage::new(inline_message_id? : String) -> SentWebAppMessage {
  { inline_message_id, }
}

///|
pub impl ToJson for SentWebAppMessage with to_json(self) {
  let object : Map[String, Json] = {}
  if self.inline_message_id is Some(v) {
    object["inline_message_id"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for SentWebAppMessage with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for SentWebAppMessage"))
  }
  let inline_message_id : String? = if object.get("inline_message_id")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { inline_message_id, }
}
