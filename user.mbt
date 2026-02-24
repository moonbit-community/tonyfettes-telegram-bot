///|
/// This object represents a Telegram user or bot.
pub struct User {
  id : Int64
  is_bot : Bool
  first_name : String
  last_name : String?
  username : String?
  language_code : String?
} derive(Show, Eq)

///|
/// Creates a new [User].
pub fn User::new(
  id~ : Int64,
  is_bot~ : Bool,
  first_name~ : String,
  last_name? : String,
  username? : String,
  language_code? : String,
) -> User {
  { id, is_bot, first_name, last_name, username, language_code }
}

///|
pub impl ToJson for User with to_json(self) {
  let object : Map[String, Json] = {
    "id": int64_to_json(self.id),
    "is_bot": self.is_bot.to_json(),
    "first_name": self.first_name.to_json(),
  }
  if self.last_name is Some(v) {
    object["last_name"] = v.to_json()
  }
  if self.username is Some(v) {
    object["username"] = v.to_json()
  }
  if self.language_code is Some(v) {
    object["language_code"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for User with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for User"))
  }
  let id : Int64 = int64_from_json(object["id"], path)
  let is_bot : Bool = @json.from_json(object["is_bot"], path~)
  let first_name : String = @json.from_json(object["first_name"], path~)
  let last_name : String? = if object.get("last_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let username : String? = if object.get("username") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let language_code : String? = if object.get("language_code") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { id, is_bot, first_name, last_name, username, language_code }
}
