///|
/// This object represents a unique message identifier.
pub struct MessageId {
  message_id : Int
} derive(Debug, Eq)

///|
/// Creates a new [MessageId].
pub fn MessageId::new(message_id~ : Int) -> MessageId {
  { message_id, }
}

///|
pub impl ToJson for MessageId with to_json(self) {
  let object : Map[String, Json] = { "message_id": self.message_id.to_json() }
  object.to_json()
}

///|
pub impl @json.FromJson for MessageId with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for MessageId"))
  }
  let message_id : Int = @json.from_json(object["message_id"], path~)
  { message_id, }
}
