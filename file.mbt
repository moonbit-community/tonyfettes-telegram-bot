///|
/// Represents a file ready to be downloaded.
pub struct File {
  file_id : String
  file_unique_id : String
  file_size : Int64?
  file_path : String?
} derive(Debug, Eq)

///|
/// Creates a new [File].
pub fn File::new(
  file_id~ : String,
  file_unique_id~ : String,
  file_size? : Int64,
  file_path? : String,
) -> File {
  { file_id, file_unique_id, file_size, file_path }
}

///|
pub impl ToJson for File with to_json(self) {
  let object : Map[String, Json] = {
    "file_id": self.file_id.to_json(),
    "file_unique_id": self.file_unique_id.to_json(),
  }
  if self.file_size is Some(v) {
    object["file_size"] = int64_to_json(v)
  }
  if self.file_path is Some(v) {
    object["file_path"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for File with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for File"))
  }
  let file_id : String = @json.from_json(object["file_id"], path~)
  let file_unique_id : String = @json.from_json(object["file_unique_id"], path~)
  let file_size : Int64? = if object.get("file_size") is Some(v) {
    Some(int64_from_json(v, path))
  } else {
    None
  }
  let file_path : String? = if object.get("file_path") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { file_id, file_unique_id, file_size, file_path }
}
