///|
/// This object represents type of a poll, which is allowed to be created and sent when the corresponding button is pressed.
pub struct KeyboardButtonPollType {
  type_ : String?
} derive(Show, Eq)

///|
/// Creates a new [KeyboardButtonPollType].
pub fn KeyboardButtonPollType::new(type_? : String) -> KeyboardButtonPollType {
  { type_, }
}

///|
pub impl ToJson for KeyboardButtonPollType with to_json(self) {
  let object : Map[String, Json] = {}
  if self.type_ is Some(v) {
    object["type"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for KeyboardButtonPollType with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for KeyboardButtonPollType"),
    )
  }
  let type_ : String? = if object.get("type") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { type_, }
}

///|
/// This object defines the criteria used to request suitable users.
pub struct KeyboardButtonRequestUsers {
  request_id : Int
  user_is_bot : Bool?
  user_is_premium : Bool?
  max_quantity : Int?
  request_name : Bool?
  request_username : Bool?
  request_photo : Bool?
} derive(Show, Eq)

///|
/// Creates a new [KeyboardButtonRequestUsers].
pub fn KeyboardButtonRequestUsers::new(
  request_id~ : Int,
  user_is_bot? : Bool,
  user_is_premium? : Bool,
  max_quantity? : Int,
  request_name? : Bool,
  request_username? : Bool,
  request_photo? : Bool,
) -> KeyboardButtonRequestUsers {
  {
    request_id,
    user_is_bot,
    user_is_premium,
    max_quantity,
    request_name,
    request_username,
    request_photo,
  }
}

///|
pub impl ToJson for KeyboardButtonRequestUsers with to_json(self) {
  let object : Map[String, Json] = { "request_id": self.request_id.to_json() }
  if self.user_is_bot is Some(v) {
    object["user_is_bot"] = v.to_json()
  }
  if self.user_is_premium is Some(v) {
    object["user_is_premium"] = v.to_json()
  }
  if self.max_quantity is Some(v) {
    object["max_quantity"] = v.to_json()
  }
  if self.request_name is Some(v) {
    object["request_name"] = v.to_json()
  }
  if self.request_username is Some(v) {
    object["request_username"] = v.to_json()
  }
  if self.request_photo is Some(v) {
    object["request_photo"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for KeyboardButtonRequestUsers with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for KeyboardButtonRequestUsers"),
    )
  }
  let request_id : Int = @json.from_json(object["request_id"], path~)
  let user_is_bot : Bool? = if object.get("user_is_bot") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let user_is_premium : Bool? = if object.get("user_is_premium") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let max_quantity : Int? = if object.get("max_quantity") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_name : Bool? = if object.get("request_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_username : Bool? = if object.get("request_username") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_photo : Bool? = if object.get("request_photo") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    request_id,
    user_is_bot,
    user_is_premium,
    max_quantity,
    request_name,
    request_username,
    request_photo,
  }
}

///|
/// This object defines the criteria used to request a suitable chat.
pub struct KeyboardButtonRequestChat {
  request_id : Int
  chat_is_channel : Bool
  chat_is_forum : Bool?
  chat_has_username : Bool?
  chat_is_created : Bool?
  bot_is_member : Bool?
  request_title : Bool?
  request_username : Bool?
  request_photo : Bool?
} derive(Show, Eq)

///|
/// Creates a new [KeyboardButtonRequestChat].
pub fn KeyboardButtonRequestChat::new(
  request_id~ : Int,
  chat_is_channel~ : Bool,
  chat_is_forum? : Bool,
  chat_has_username? : Bool,
  chat_is_created? : Bool,
  bot_is_member? : Bool,
  request_title? : Bool,
  request_username? : Bool,
  request_photo? : Bool,
) -> KeyboardButtonRequestChat {
  {
    request_id,
    chat_is_channel,
    chat_is_forum,
    chat_has_username,
    chat_is_created,
    bot_is_member,
    request_title,
    request_username,
    request_photo,
  }
}

///|
pub impl ToJson for KeyboardButtonRequestChat with to_json(self) {
  let object : Map[String, Json] = {
    "request_id": self.request_id.to_json(),
    "chat_is_channel": self.chat_is_channel.to_json(),
  }
  if self.chat_is_forum is Some(v) {
    object["chat_is_forum"] = v.to_json()
  }
  if self.chat_has_username is Some(v) {
    object["chat_has_username"] = v.to_json()
  }
  if self.chat_is_created is Some(v) {
    object["chat_is_created"] = v.to_json()
  }
  if self.bot_is_member is Some(v) {
    object["bot_is_member"] = v.to_json()
  }
  if self.request_title is Some(v) {
    object["request_title"] = v.to_json()
  }
  if self.request_username is Some(v) {
    object["request_username"] = v.to_json()
  }
  if self.request_photo is Some(v) {
    object["request_photo"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for KeyboardButtonRequestChat with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for KeyboardButtonRequestChat"),
    )
  }
  let request_id : Int = @json.from_json(object["request_id"], path~)
  let chat_is_channel : Bool = @json.from_json(object["chat_is_channel"], path~)
  let chat_is_forum : Bool? = if object.get("chat_is_forum") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let chat_has_username : Bool? = if object.get("chat_has_username") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let chat_is_created : Bool? = if object.get("chat_is_created") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let bot_is_member : Bool? = if object.get("bot_is_member") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_title : Bool? = if object.get("request_title") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_username : Bool? = if object.get("request_username") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_photo : Bool? = if object.get("request_photo") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    request_id,
    chat_is_channel,
    chat_is_forum,
    chat_has_username,
    chat_is_created,
    bot_is_member,
    request_title,
    request_username,
    request_photo,
  }
}

///|
/// This object represents one button of the reply keyboard.
pub struct KeyboardButton {
  text : String
  request_users : KeyboardButtonRequestUsers?
  request_chat : KeyboardButtonRequestChat?
  request_contact : Bool?
  request_location : Bool?
  request_poll : KeyboardButtonPollType?
  web_app : WebAppInfo?
} derive(Show, Eq)

///|
/// Creates a new [KeyboardButton].
pub fn KeyboardButton::new(
  text~ : String,
  request_users? : KeyboardButtonRequestUsers,
  request_chat? : KeyboardButtonRequestChat,
  request_contact? : Bool,
  request_location? : Bool,
  request_poll? : KeyboardButtonPollType,
  web_app? : WebAppInfo,
) -> KeyboardButton {
  {
    text,
    request_users,
    request_chat,
    request_contact,
    request_location,
    request_poll,
    web_app,
  }
}

///|
pub impl ToJson for KeyboardButton with to_json(self) {
  let object : Map[String, Json] = { "text": self.text.to_json() }
  if self.request_users is Some(v) {
    object["request_users"] = v.to_json()
  }
  if self.request_chat is Some(v) {
    object["request_chat"] = v.to_json()
  }
  if self.request_contact is Some(v) {
    object["request_contact"] = v.to_json()
  }
  if self.request_location is Some(v) {
    object["request_location"] = v.to_json()
  }
  if self.request_poll is Some(v) {
    object["request_poll"] = v.to_json()
  }
  if self.web_app is Some(v) {
    object["web_app"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for KeyboardButton with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for KeyboardButton"))
  }
  let text : String = @json.from_json(object["text"], path~)
  let request_users : KeyboardButtonRequestUsers? = if object.get(
      "request_users",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_chat : KeyboardButtonRequestChat? = if object.get("request_chat")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_contact : Bool? = if object.get("request_contact") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_location : Bool? = if object.get("request_location") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_poll : KeyboardButtonPollType? = if object.get("request_poll")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let web_app : WebAppInfo? = if object.get("web_app") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    text,
    request_users,
    request_chat,
    request_contact,
    request_location,
    request_poll,
    web_app,
  }
}
