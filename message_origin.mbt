///|
/// The message was originally sent by a known user.
pub struct MessageOriginUser {
  date : Int
  sender_user : User
} derive(Show, Eq)

///|
/// Creates a new [MessageOriginUser].
pub fn MessageOriginUser::new(
  date~ : Int,
  sender_user~ : User,
) -> MessageOriginUser {
  { date, sender_user }
}

///|
/// The message was originally sent by an unknown user.
pub struct MessageOriginHiddenUser {
  date : Int
  sender_user_name : String
} derive(Show, Eq)

///|
/// Creates a new [MessageOriginHiddenUser].
pub fn MessageOriginHiddenUser::new(
  date~ : Int,
  sender_user_name~ : String,
) -> MessageOriginHiddenUser {
  { date, sender_user_name }
}

///|
/// The message was originally sent on behalf of a chat to a group chat.
pub struct MessageOriginChat {
  date : Int
  sender_chat : Chat
  author_signature : String?
} derive(Show, Eq)

///|
/// Creates a new [MessageOriginChat].
pub fn MessageOriginChat::new(
  date~ : Int,
  sender_chat~ : Chat,
  author_signature? : String,
) -> MessageOriginChat {
  { date, sender_chat, author_signature }
}

///|
/// The message was originally sent to a channel chat.
pub struct MessageOriginChannel {
  date : Int
  chat : Chat
  message_id : Int
  author_signature : String?
} derive(Show, Eq)

///|
/// Creates a new [MessageOriginChannel].
pub fn MessageOriginChannel::new(
  date~ : Int,
  chat~ : Chat,
  message_id~ : Int,
  author_signature? : String,
) -> MessageOriginChannel {
  { date, chat, message_id, author_signature }
}

///|
/// Placeholder for the MessageOrigin type.
pub(all) enum MessageOrigin {
  User(MessageOriginUser)
  HiddenUser(MessageOriginHiddenUser)
  Chat(MessageOriginChat)
  Channel(MessageOriginChannel)
} derive(Show, Eq)

///|
pub impl ToJson for MessageOrigin with to_json(self) {
  match self {
    User(v) => {
      let object : Map[String, Json] = {
        "type": "user".to_json(),
        "date": v.date.to_json(),
        "sender_user": v.sender_user.to_json(),
      }
      object.to_json()
    }
    HiddenUser(v) => {
      let object : Map[String, Json] = {
        "type": "hidden_user".to_json(),
        "date": v.date.to_json(),
        "sender_user_name": v.sender_user_name.to_json(),
      }
      object.to_json()
    }
    Chat(v) => {
      let object : Map[String, Json] = {
        "type": "chat".to_json(),
        "date": v.date.to_json(),
        "sender_chat": v.sender_chat.to_json(),
      }
      if v.author_signature is Some(sig) {
        object["author_signature"] = sig.to_json()
      }
      object.to_json()
    }
    Channel(v) => {
      let object : Map[String, Json] = {
        "type": "channel".to_json(),
        "date": v.date.to_json(),
        "chat": v.chat.to_json(),
        "message_id": v.message_id.to_json(),
      }
      if v.author_signature is Some(sig) {
        object["author_signature"] = sig.to_json()
      }
      object.to_json()
    }
  }
}

///|
pub impl @json.FromJson for MessageOrigin with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for MessageOrigin"))
  }
  guard object["type"] is String(type_) else {
    raise @json.JsonDecodeError((path, "Expected type field for MessageOrigin"))
  }
  match type_ {
    "user" => {
      let date : Int = @json.from_json(object["date"], path~)
      let sender_user : User = @json.from_json(object["sender_user"], path~)
      User({ date, sender_user })
    }
    "hidden_user" => {
      let date : Int = @json.from_json(object["date"], path~)
      let sender_user_name : String = @json.from_json(
        object["sender_user_name"],
        path~,
      )
      HiddenUser({ date, sender_user_name })
    }
    "chat" => {
      let date : Int = @json.from_json(object["date"], path~)
      let sender_chat : Chat = @json.from_json(object["sender_chat"], path~)
      let author_signature : String? = if object.get("author_signature")
        is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Chat({ date, sender_chat, author_signature })
    }
    "channel" => {
      let date : Int = @json.from_json(object["date"], path~)
      let chat : Chat = @json.from_json(object["chat"], path~)
      let message_id : Int = @json.from_json(object["message_id"], path~)
      let author_signature : String? = if object.get("author_signature")
        is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Channel({ date, chat, message_id, author_signature })
    }
    _ =>
      raise @json.JsonDecodeError(
        (path, "Unknown MessageOrigin type: \{type_}"),
      )
  }
}
