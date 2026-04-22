///|
/// This object represents a chat photo.
pub struct ChatPhoto {
  small_file_id : String
  small_file_unique_id : String
  big_file_id : String
  big_file_unique_id : String
} derive(Debug, Eq)

///|
/// Creates a new [ChatPhoto].
pub fn ChatPhoto::new(
  small_file_id~ : String,
  small_file_unique_id~ : String,
  big_file_id~ : String,
  big_file_unique_id~ : String,
) -> ChatPhoto {
  { small_file_id, small_file_unique_id, big_file_id, big_file_unique_id }
}

///|
pub impl ToJson for ChatPhoto with to_json(self) {
  let object : Map[String, Json] = {
    "small_file_id": self.small_file_id.to_json(),
    "small_file_unique_id": self.small_file_unique_id.to_json(),
    "big_file_id": self.big_file_id.to_json(),
    "big_file_unique_id": self.big_file_unique_id.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for ChatPhoto with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for ChatPhoto"))
  }
  let small_file_id : String = @json.from_json(object["small_file_id"], path~)
  let small_file_unique_id : String = @json.from_json(
    object["small_file_unique_id"],
    path~,
  )
  let big_file_id : String = @json.from_json(object["big_file_id"], path~)
  let big_file_unique_id : String = @json.from_json(
    object["big_file_unique_id"],
    path~,
  )
  { small_file_id, small_file_unique_id, big_file_id, big_file_unique_id }
}
