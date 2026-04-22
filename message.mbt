///|
/// This object represents one special entity in a text message.
/// For example, hashtags, usernames, URLs, etc.
pub struct MessageEntity {
  type_ : String
  offset : Int
  length : Int
  url : String?
  user : User?
  language : String?
} derive(Debug, Eq)

///|
/// Creates a new [MessageEntity].
pub fn MessageEntity::new(
  type_~ : String,
  offset~ : Int,
  length~ : Int,
  url? : String,
  user? : User,
  language? : String,
) -> MessageEntity {
  { type_, offset, length, url, user, language }
}

///|
pub impl ToJson for MessageEntity with to_json(self) {
  let object : Map[String, Json] = {
    "type": self.type_.to_json(),
    "offset": self.offset.to_json(),
    "length": self.length.to_json(),
  }
  if self.url is Some(v) {
    object["url"] = v.to_json()
  }
  if self.user is Some(v) {
    object["user"] = v.to_json()
  }
  if self.language is Some(v) {
    object["language"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for MessageEntity with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for MessageEntity"))
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let offset : Int = @json.from_json(object["offset"], path~)
  let length : Int = @json.from_json(object["length"], path~)
  let url : String? = if object.get("url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let user : User? = if object.get("user") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let language : String? = if object.get("language") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { type_, offset, length, url, user, language }
}

///|
/// This object represents a message.
pub struct Message {
  message_id : Int
  from : User?
  date : Int
  chat : Chat
  text : String?
  entities : Array[MessageEntity]?
  reply_to_message : Message?
  message_thread_id : Int?
  is_topic_message : Bool?
  direct_messages_topic : DirectMessagesTopic?
  gift_upgrade_sent : GiftInfo?
  gift_id : String?
  is_from_blockchain : Bool?
} derive(Debug, Eq)

///|
/// Creates a new [Message].
pub fn Message::new(
  message_id~ : Int,
  from? : User,
  date~ : Int,
  chat~ : Chat,
  text? : String,
  entities? : Array[MessageEntity],
  reply_to_message? : Message,
  message_thread_id? : Int,
  is_topic_message? : Bool,
  direct_messages_topic? : DirectMessagesTopic,
  gift_upgrade_sent? : GiftInfo,
  gift_id? : String,
  is_from_blockchain? : Bool,
) -> Message {
  {
    message_id,
    from,
    date,
    chat,
    text,
    entities,
    reply_to_message,
    message_thread_id,
    is_topic_message,
    direct_messages_topic,
    gift_upgrade_sent,
    gift_id,
    is_from_blockchain,
  }
}

///|
pub impl ToJson for Message with to_json(self) {
  let object : Map[String, Json] = {
    "message_id": self.message_id.to_json(),
    "date": self.date.to_json(),
    "chat": self.chat.to_json(),
  }
  if self.from is Some(v) {
    object["from"] = v.to_json()
  }
  if self.text is Some(v) {
    object["text"] = v.to_json()
  }
  if self.entities is Some(v) {
    object["entities"] = v.to_json()
  }
  if self.reply_to_message is Some(v) {
    object["reply_to_message"] = v.to_json()
  }
  if self.message_thread_id is Some(v) {
    object["message_thread_id"] = v.to_json()
  }
  if self.is_topic_message is Some(v) {
    object["is_topic_message"] = v.to_json()
  }
  if self.direct_messages_topic is Some(v) {
    object["direct_messages_topic"] = v.to_json()
  }
  if self.gift_upgrade_sent is Some(v) {
    object["gift_upgrade_sent"] = v.to_json()
  }
  if self.gift_id is Some(v) {
    object["gift_id"] = v.to_json()
  }
  if self.is_from_blockchain is Some(v) {
    object["is_from_blockchain"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for Message with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for Message"))
  }
  let message_id : Int = @json.from_json(object["message_id"], path~)
  let from : User? = if object.get("from") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let date : Int = @json.from_json(object["date"], path~)
  let chat : Chat = @json.from_json(object["chat"], path~)
  let text : String? = if object.get("text") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let entities : Array[MessageEntity]? = if object.get("entities") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_to_message : Message? = if object.get("reply_to_message") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let message_thread_id : Int? = if object.get("message_thread_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let is_topic_message : Bool? = if object.get("is_topic_message") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let direct_messages_topic : DirectMessagesTopic? = if object.get(
      "direct_messages_topic",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let gift_upgrade_sent : GiftInfo? = if object.get("gift_upgrade_sent")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let gift_id : String? = if object.get("gift_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let is_from_blockchain : Bool? = if object.get("is_from_blockchain")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    message_id,
    from,
    date,
    chat,
    text,
    entities,
    reply_to_message,
    message_thread_id,
    is_topic_message,
    direct_messages_topic,
    gift_upgrade_sent,
    gift_id,
    is_from_blockchain,
  }
}
