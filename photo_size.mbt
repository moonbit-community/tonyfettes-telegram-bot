///|
/// Represents one size of a photo or a file/sticker thumbnail.
pub struct PhotoSize {
  file_id : String
  file_unique_id : String
  width : Int
  height : Int
  file_size : Int64?
} derive(Show, Eq)

///|
/// Creates a new [PhotoSize].
pub fn PhotoSize::new(
  file_id~ : String,
  file_unique_id~ : String,
  width~ : Int,
  height~ : Int,
  file_size? : Int64,
) -> PhotoSize {
  { file_id, file_unique_id, width, height, file_size }
}

///|
pub impl ToJson for PhotoSize with to_json(self) {
  let object : Map[String, Json] = {
    "file_id": self.file_id.to_json(),
    "file_unique_id": self.file_unique_id.to_json(),
    "width": self.width.to_json(),
    "height": self.height.to_json(),
  }
  if self.file_size is Some(v) {
    object["file_size"] = int64_to_json(v)
  }
  object.to_json()
}

///|
pub impl @json.FromJson for PhotoSize with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for PhotoSize"))
  }
  let file_id : String = @json.from_json(object["file_id"], path~)
  let file_unique_id : String = @json.from_json(object["file_unique_id"], path~)
  let width : Int = @json.from_json(object["width"], path~)
  let height : Int = @json.from_json(object["height"], path~)
  let file_size : Int64? = if object.get("file_size") is Some(v) {
    Some(int64_from_json(v, path))
  } else {
    None
  }
  { file_id, file_unique_id, width, height, file_size }
}
