///|
/// Represents a voice note.
pub struct Voice {
  file_id : String
  file_unique_id : String
  duration : Int
  mime_type : String?
  file_size : Int64?
} derive(Show, Eq)

///|
/// Creates a new [Voice].
pub fn Voice::new(
  file_id~ : String,
  file_unique_id~ : String,
  duration~ : Int,
  mime_type? : String,
  file_size? : Int64,
) -> Voice {
  { file_id, file_unique_id, duration, mime_type, file_size }
}

///|
pub impl ToJson for Voice with to_json(self) {
  let object : Map[String, Json] = {
    "file_id": self.file_id.to_json(),
    "file_unique_id": self.file_unique_id.to_json(),
    "duration": self.duration.to_json(),
  }
  if self.mime_type is Some(v) {
    object["mime_type"] = v.to_json()
  }
  if self.file_size is Some(v) {
    object["file_size"] = int64_to_json(v)
  }
  object.to_json()
}

///|
pub impl @json.FromJson for Voice with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for Voice"))
  }
  let file_id : String = @json.from_json(object["file_id"], path~)
  let file_unique_id : String = @json.from_json(object["file_unique_id"], path~)
  let duration : Int = @json.from_json(object["duration"], path~)
  let mime_type : String? = if object.get("mime_type") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let file_size : Int64? = if object.get("file_size") is Some(v) {
    Some(int64_from_json(v, path))
  } else {
    None
  }
  { file_id, file_unique_id, duration, mime_type, file_size }
}
