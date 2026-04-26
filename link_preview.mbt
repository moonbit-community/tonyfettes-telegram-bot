///|
/// Describes the options used for link preview generation.
pub struct LinkPreviewOptions {
  is_disabled : Bool?
  url : String?
  prefer_small_media : Bool?
  prefer_large_media : Bool?
  show_above_text : Bool?
} derive(Debug, Eq)

///|
/// Creates a new [LinkPreviewOptions].
pub fn LinkPreviewOptions::new(
  is_disabled? : Bool,
  url? : String,
  prefer_small_media? : Bool,
  prefer_large_media? : Bool,
  show_above_text? : Bool,
) -> LinkPreviewOptions {
  { is_disabled, url, prefer_small_media, prefer_large_media, show_above_text }
}

///|
pub impl ToJson for LinkPreviewOptions with to_json(self) {
  let object : Map[String, Json] = {}
  if self.is_disabled is Some(v) {
    object["is_disabled"] = v.to_json()
  }
  if self.url is Some(v) {
    object["url"] = v.to_json()
  }
  if self.prefer_small_media is Some(v) {
    object["prefer_small_media"] = v.to_json()
  }
  if self.prefer_large_media is Some(v) {
    object["prefer_large_media"] = v.to_json()
  }
  if self.show_above_text is Some(v) {
    object["show_above_text"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for LinkPreviewOptions with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for LinkPreviewOptions"),
    )
  }
  let is_disabled : Bool? = if object.get("is_disabled") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let url : String? = if object.get("url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let prefer_small_media : Bool? = if object.get("prefer_small_media")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let prefer_large_media : Bool? = if object.get("prefer_large_media")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let show_above_text : Bool? = if object.get("show_above_text") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { is_disabled, url, prefer_small_media, prefer_large_media, show_above_text }
}

///|
/// This object contains information about the quoted part of a message that is replied to by the given message.
pub struct TextQuote {
  text : String
  entities : Array[MessageEntity]?
  position : Int
  is_manual : Bool?
} derive(Debug, Eq)

///|
/// Creates a new [TextQuote].
pub fn TextQuote::new(
  text~ : String,
  entities? : Array[MessageEntity],
  position~ : Int,
  is_manual? : Bool,
) -> TextQuote {
  { text, entities, position, is_manual }
}

///|
pub impl ToJson for TextQuote with to_json(self) {
  let object : Map[String, Json] = {
    "text": self.text.to_json(),
    "position": self.position.to_json(),
  }
  if self.entities is Some(v) {
    object["entities"] = v.to_json()
  }
  if self.is_manual is Some(v) {
    object["is_manual"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for TextQuote with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for TextQuote"))
  }
  let text : String = @json.from_json(object["text"], path~)
  let entities : Array[MessageEntity]? = if object.get("entities") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let position : Int = @json.from_json(object["position"], path~)
  let is_manual : Bool? = if object.get("is_manual") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { text, entities, position, is_manual }
}
