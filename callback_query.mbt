///|
/// This object represents an incoming callback query from a callback button
/// in an inline keyboard.
pub struct CallbackQuery {
  id : String
  from : User
  message : Message?
  inline_message_id : String?
  chat_instance : String
  data : String?
} derive(Debug, Eq)

///|
/// Creates a new [CallbackQuery].
pub fn CallbackQuery::new(
  id~ : String,
  from~ : User,
  message? : Message,
  inline_message_id? : String,
  chat_instance~ : String,
  data? : String,
) -> CallbackQuery {
  { id, from, message, inline_message_id, chat_instance, data }
}

///|
pub impl ToJson for CallbackQuery with to_json(self) {
  let object : Map[String, Json] = {
    "id": self.id.to_json(),
    "from": self.from.to_json(),
    "chat_instance": self.chat_instance.to_json(),
  }
  if self.message is Some(v) {
    object["message"] = v.to_json()
  }
  if self.inline_message_id is Some(v) {
    object["inline_message_id"] = v.to_json()
  }
  if self.data is Some(v) {
    object["data"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for CallbackQuery with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for CallbackQuery"))
  }
  let id : String = @json.from_json(object["id"], path~)
  let from : User = @json.from_json(object["from"], path~)
  let message : Message? = if object.get("message") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let inline_message_id : String? = if object.get("inline_message_id")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let chat_instance : String = @json.from_json(object["chat_instance"], path~)
  let data : String? = if object.get("data") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { id, from, message, inline_message_id, chat_instance, data }
}
