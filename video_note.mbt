///|
/// Represents a video message (available in Telegram apps as of v.4.0).
pub struct VideoNote {
  file_id : String
  file_unique_id : String
  length : Int
  duration : Int
  thumbnail : PhotoSize?
  file_size : Int64?
} derive(Show, Eq)

///|
/// Creates a new [VideoNote].
pub fn VideoNote::new(
  file_id~ : String,
  file_unique_id~ : String,
  length~ : Int,
  duration~ : Int,
  thumbnail? : PhotoSize,
  file_size? : Int64,
) -> VideoNote {
  { file_id, file_unique_id, length, duration, thumbnail, file_size }
}

///|
pub impl ToJson for VideoNote with to_json(self) {
  let object : Map[String, Json] = {
    "file_id": self.file_id.to_json(),
    "file_unique_id": self.file_unique_id.to_json(),
    "length": self.length.to_json(),
    "duration": self.duration.to_json(),
  }
  if self.thumbnail is Some(v) {
    object["thumbnail"] = v.to_json()
  }
  if self.file_size is Some(v) {
    object["file_size"] = int64_to_json(v)
  }
  object.to_json()
}

///|
pub impl @json.FromJson for VideoNote with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for VideoNote"))
  }
  let file_id : String = @json.from_json(object["file_id"], path~)
  let file_unique_id : String = @json.from_json(object["file_unique_id"], path~)
  let length : Int = @json.from_json(object["length"], path~)
  let duration : Int = @json.from_json(object["duration"], path~)
  let thumbnail : PhotoSize? = if object.get("thumbnail") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let file_size : Int64? = if object.get("file_size") is Some(v) {
    Some(int64_from_json(v, path))
  } else {
    None
  }
  { file_id, file_unique_id, length, duration, thumbnail, file_size }
}
