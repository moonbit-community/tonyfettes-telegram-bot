///|
/// This object represents a parameter of the inline keyboard button used to automatically authorize a user.
pub struct LoginUrl {
  url : String
  forward_text : String?
  bot_username : String?
  request_write_access : Bool?
} derive(Debug, Eq)

///|
/// Creates a new [LoginUrl].
pub fn LoginUrl::new(
  url~ : String,
  forward_text? : String,
  bot_username? : String,
  request_write_access? : Bool,
) -> LoginUrl {
  { url, forward_text, bot_username, request_write_access }
}

///|
pub impl ToJson for LoginUrl with to_json(self) {
  let object : Map[String, Json] = { "url": self.url.to_json() }
  if self.forward_text is Some(v) {
    object["forward_text"] = v.to_json()
  }
  if self.bot_username is Some(v) {
    object["bot_username"] = v.to_json()
  }
  if self.request_write_access is Some(v) {
    object["request_write_access"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for LoginUrl with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for LoginUrl"))
  }
  let url : String = @json.from_json(object["url"], path~)
  let forward_text : String? = if object.get("forward_text") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let bot_username : String? = if object.get("bot_username") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_write_access : Bool? = if object.get("request_write_access")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { url, forward_text, bot_username, request_write_access }
}

///|
/// This object represents an inline button that switches the current user to inline mode in a chosen chat, with an optional default inline query.
pub struct SwitchInlineQueryChosenChat {
  query : String?
  allow_user_chats : Bool?
  allow_bot_chats : Bool?
  allow_group_chats : Bool?
  allow_channel_chats : Bool?
} derive(Debug, Eq)

///|
/// Creates a new [SwitchInlineQueryChosenChat].
pub fn SwitchInlineQueryChosenChat::new(
  query? : String,
  allow_user_chats? : Bool,
  allow_bot_chats? : Bool,
  allow_group_chats? : Bool,
  allow_channel_chats? : Bool,
) -> SwitchInlineQueryChosenChat {
  {
    query,
    allow_user_chats,
    allow_bot_chats,
    allow_group_chats,
    allow_channel_chats,
  }
}

///|
pub impl ToJson for SwitchInlineQueryChosenChat with to_json(self) {
  let object : Map[String, Json] = {}
  if self.query is Some(v) {
    object["query"] = v.to_json()
  }
  if self.allow_user_chats is Some(v) {
    object["allow_user_chats"] = v.to_json()
  }
  if self.allow_bot_chats is Some(v) {
    object["allow_bot_chats"] = v.to_json()
  }
  if self.allow_group_chats is Some(v) {
    object["allow_group_chats"] = v.to_json()
  }
  if self.allow_channel_chats is Some(v) {
    object["allow_channel_chats"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for SwitchInlineQueryChosenChat with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for SwitchInlineQueryChosenChat"),
    )
  }
  let query : String? = if object.get("query") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let allow_user_chats : Bool? = if object.get("allow_user_chats") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let allow_bot_chats : Bool? = if object.get("allow_bot_chats") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let allow_group_chats : Bool? = if object.get("allow_group_chats") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let allow_channel_chats : Bool? = if object.get("allow_channel_chats")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    query,
    allow_user_chats,
    allow_bot_chats,
    allow_group_chats,
    allow_channel_chats,
  }
}

///|
/// A placeholder, currently holds no information. Use BotFather to set up your game.
pub struct CallbackGame {} derive(Debug, Eq)

///|
/// Creates a new [CallbackGame].
pub fn CallbackGame::new() -> CallbackGame {
  CallbackGame::{  }
}

///|
pub impl ToJson for CallbackGame with to_json(_self) {
  let object : Map[String, Json] = {}
  object.to_json()
}

///|
pub impl @json.FromJson for CallbackGame with from_json(json, path) {
  guard json is Object(_) else {
    raise @json.JsonDecodeError((path, "Expected object for CallbackGame"))
  }
  CallbackGame::{  }
}
