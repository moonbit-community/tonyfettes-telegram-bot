///|
/// Type of chat, can be either 'private', 'group', 'supergroup' or 'channel'.
pub(all) enum ChatType {
  Private
  Group
  Supergroup
  Channel
} derive(Show, Eq)

///|
pub impl ToJson for ChatType with to_json(self) {
  match self {
    Private => "private".to_json()
    Group => "group".to_json()
    Supergroup => "supergroup".to_json()
    Channel => "channel".to_json()
  }
}

///|
pub impl @json.FromJson for ChatType with from_json(json, path) {
  guard json is String(s) else {
    raise @json.JsonDecodeError((path, "Expected string for ChatType"))
  }
  match s {
    "private" => Private
    "group" => Group
    "supergroup" => Supergroup
    "channel" => Channel
    _ => raise @json.JsonDecodeError((path, "Unknown ChatType: \{s}"))
  }
}

///|
/// This object represents a chat.
pub struct Chat {
  id : Int64
  type_ : ChatType
  title : String?
  username : String?
  first_name : String?
  last_name : String?
} derive(Show, Eq)

///|
/// Creates a new [Chat].
pub fn Chat::new(
  id~ : Int64,
  type_~ : ChatType,
  title? : String,
  username? : String,
  first_name? : String,
  last_name? : String,
) -> Chat {
  { id, type_, title, username, first_name, last_name }
}

///|
pub impl ToJson for Chat with to_json(self) {
  let object : Map[String, Json] = {
    "id": int64_to_json(self.id),
    "type": self.type_.to_json(),
  }
  if self.title is Some(v) {
    object["title"] = v.to_json()
  }
  if self.username is Some(v) {
    object["username"] = v.to_json()
  }
  if self.first_name is Some(v) {
    object["first_name"] = v.to_json()
  }
  if self.last_name is Some(v) {
    object["last_name"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for Chat with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for Chat"))
  }
  let id : Int64 = int64_from_json(object["id"], path)
  let type_ : ChatType = @json.from_json(object["type"], path~)
  let title : String? = if object.get("title") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let username : String? = if object.get("username") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let first_name : String? = if object.get("first_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let last_name : String? = if object.get("last_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { id, type_, title, username, first_name, last_name }
}
