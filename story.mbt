///|
/// Represents a story.
pub struct Story {
  chat : Chat
  id : Int
} derive(Show, Eq)

///|
/// Creates a new [Story].
pub fn Story::new(chat~ : Chat, id~ : Int) -> Story {
  { chat, id }
}

///|
pub impl ToJson for Story with to_json(self) {
  let object : Map[String, Json] = {
    "chat": self.chat.to_json(),
    "id": self.id.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for Story with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for Story"))
  }
  let chat : Chat = @json.from_json(object["chat"], path~)
  let id : Int = @json.from_json(object["id"], path~)
  { chat, id }
}
