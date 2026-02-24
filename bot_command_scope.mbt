///|
/// Represents the scope of bot commands, covering a specific chat.
pub struct BotCommandScopeChat {
  chat_id : Int64
} derive(Show, Eq)

///|
/// Creates a new [BotCommandScopeChat].
pub fn BotCommandScopeChat::new(chat_id~ : Int64) -> BotCommandScopeChat {
  { chat_id, }
}

///|
/// Represents the scope of bot commands, covering all administrators of a specific chat.
pub struct BotCommandScopeChatAdministrators {
  chat_id : Int64
} derive(Show, Eq)

///|
/// Creates a new [BotCommandScopeChatAdministrators].
pub fn BotCommandScopeChatAdministrators::new(
  chat_id~ : Int64,
) -> BotCommandScopeChatAdministrators {
  { chat_id, }
}

///|
/// Represents the scope of bot commands, covering a specific member of a group or supergroup chat.
pub struct BotCommandScopeChatMember {
  chat_id : Int64
  user_id : Int64
} derive(Show, Eq)

///|
/// Creates a new [BotCommandScopeChatMember].
pub fn BotCommandScopeChatMember::new(
  chat_id~ : Int64,
  user_id~ : Int64,
) -> BotCommandScopeChatMember {
  { chat_id, user_id }
}

///|
/// This object represents the scope to which bot commands are applied.
pub(all) enum BotCommandScope {
  Default
  AllPrivateChats
  AllGroupChats
  AllChatAdministrators
  Chat(BotCommandScopeChat)
  ChatAdministrators(BotCommandScopeChatAdministrators)
  ChatMember(BotCommandScopeChatMember)
} derive(Show, Eq)

///|
pub impl ToJson for BotCommandScope with to_json(self) {
  match self {
    Default => {
      let object : Map[String, Json] = { "type": "default".to_json() }
      object.to_json()
    }
    AllPrivateChats => {
      let object : Map[String, Json] = { "type": "all_private_chats".to_json() }
      object.to_json()
    }
    AllGroupChats => {
      let object : Map[String, Json] = { "type": "all_group_chats".to_json() }
      object.to_json()
    }
    AllChatAdministrators => {
      let object : Map[String, Json] = {
        "type": "all_chat_administrators".to_json(),
      }
      object.to_json()
    }
    Chat(v) => {
      let object : Map[String, Json] = {
        "type": "chat".to_json(),
        "chat_id": int64_to_json(v.chat_id),
      }
      object.to_json()
    }
    ChatAdministrators(v) => {
      let object : Map[String, Json] = {
        "type": "chat_administrators".to_json(),
        "chat_id": int64_to_json(v.chat_id),
      }
      object.to_json()
    }
    ChatMember(v) => {
      let object : Map[String, Json] = {
        "type": "chat_member".to_json(),
        "chat_id": int64_to_json(v.chat_id),
        "user_id": int64_to_json(v.user_id),
      }
      object.to_json()
    }
  }
}

///|
pub impl @json.FromJson for BotCommandScope with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for BotCommandScope"))
  }
  guard object["type"] is String(type_) else {
    raise @json.JsonDecodeError(
      (path, "Expected type field for BotCommandScope"),
    )
  }
  match type_ {
    "default" => Default
    "all_private_chats" => AllPrivateChats
    "all_group_chats" => AllGroupChats
    "all_chat_administrators" => AllChatAdministrators
    "chat" => {
      let chat_id : Int64 = int64_from_json(object["chat_id"], path)
      Chat({ chat_id, })
    }
    "chat_administrators" => {
      let chat_id : Int64 = int64_from_json(object["chat_id"], path)
      ChatAdministrators({ chat_id, })
    }
    "chat_member" => {
      let chat_id : Int64 = int64_from_json(object["chat_id"], path)
      let user_id : Int64 = int64_from_json(object["user_id"], path)
      ChatMember({ chat_id, user_id })
    }
    _ =>
      raise @json.JsonDecodeError(
        (path, "Unknown BotCommandScope type: \{type_}"),
      )
  }
}
