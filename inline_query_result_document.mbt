///|
/// Placeholder for the InputMessageContent type.
pub struct InputMessageContentPlaceholder {
  message_text : String
} derive(Debug, Eq)

///|
/// Creates a new [InputMessageContentPlaceholder].
pub fn InputMessageContentPlaceholder::new(
  message_text~ : String,
) -> InputMessageContentPlaceholder {
  { message_text, }
}

///|
pub impl ToJson for InputMessageContentPlaceholder with to_json(self) {
  let object : Map[String, Json] = {
    "message_text": self.message_text.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for InputMessageContentPlaceholder with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InputMessageContentPlaceholder"),
    )
  }
  let message_text : String = @json.from_json(object["message_text"], path~)
  { message_text, }
}

///|
/// Represents a link to an MP3 audio file. By default, this audio file will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the audio.
pub struct InlineQueryResultAudio {
  type_ : String
  id : String
  audio_url : String
  title : String
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  performer : String?
  audio_duration : Int?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputMessageContentPlaceholder?
} derive(Debug, Eq)

///|
/// Creates a new [InlineQueryResultAudio].
pub fn InlineQueryResultAudio::new(
  id~ : String,
  audio_url~ : String,
  title~ : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  performer? : String,
  audio_duration? : Int,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputMessageContentPlaceholder,
) -> InlineQueryResultAudio {
  {
    type_: "audio",
    id,
    audio_url,
    title,
    caption,
    parse_mode,
    caption_entities,
    performer,
    audio_duration,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl ToJson for InlineQueryResultAudio with to_json(self) {
  let object : Map[String, Json] = {
    "type": self.type_.to_json(),
    "id": self.id.to_json(),
    "audio_url": self.audio_url.to_json(),
    "title": self.title.to_json(),
  }
  if self.caption is Some(v) {
    object["caption"] = v.to_json()
  }
  if self.parse_mode is Some(v) {
    object["parse_mode"] = v.to_json()
  }
  if self.caption_entities is Some(v) {
    object["caption_entities"] = v.to_json()
  }
  if self.performer is Some(v) {
    object["performer"] = v.to_json()
  }
  if self.audio_duration is Some(v) {
    object["audio_duration"] = v.to_json()
  }
  if self.reply_markup is Some(v) {
    object["reply_markup"] = v.to_json()
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for InlineQueryResultAudio with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InlineQueryResultAudio"),
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let audio_url : String = @json.from_json(object["audio_url"], path~)
  let title : String = @json.from_json(object["title"], path~)
  let caption : String? = if object.get("caption") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let parse_mode : String? = if object.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption_entities : Array[MessageEntity]? = if object.get(
      "caption_entities",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let performer : String? = if object.get("performer") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let audio_duration : Int? = if object.get("audio_duration") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : InputMessageContentPlaceholder? = if object.get(
      "input_message_content",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    id,
    audio_url,
    title,
    caption,
    parse_mode,
    caption_entities,
    performer,
    audio_duration,
    reply_markup,
    input_message_content,
  }
}

///|
/// Represents a link to a voice recording in an .OGG container encoded with OPUS. By default, this voice recording will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the voice message.
pub struct InlineQueryResultVoice {
  type_ : String
  id : String
  voice_url : String
  title : String
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  voice_duration : Int?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputMessageContentPlaceholder?
} derive(Debug, Eq)

///|
/// Creates a new [InlineQueryResultVoice].
pub fn InlineQueryResultVoice::new(
  id~ : String,
  voice_url~ : String,
  title~ : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  voice_duration? : Int,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputMessageContentPlaceholder,
) -> InlineQueryResultVoice {
  {
    type_: "voice",
    id,
    voice_url,
    title,
    caption,
    parse_mode,
    caption_entities,
    voice_duration,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl ToJson for InlineQueryResultVoice with to_json(self) {
  let object : Map[String, Json] = {
    "type": self.type_.to_json(),
    "id": self.id.to_json(),
    "voice_url": self.voice_url.to_json(),
    "title": self.title.to_json(),
  }
  if self.caption is Some(v) {
    object["caption"] = v.to_json()
  }
  if self.parse_mode is Some(v) {
    object["parse_mode"] = v.to_json()
  }
  if self.caption_entities is Some(v) {
    object["caption_entities"] = v.to_json()
  }
  if self.voice_duration is Some(v) {
    object["voice_duration"] = v.to_json()
  }
  if self.reply_markup is Some(v) {
    object["reply_markup"] = v.to_json()
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for InlineQueryResultVoice with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InlineQueryResultVoice"),
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let voice_url : String = @json.from_json(object["voice_url"], path~)
  let title : String = @json.from_json(object["title"], path~)
  let caption : String? = if object.get("caption") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let parse_mode : String? = if object.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption_entities : Array[MessageEntity]? = if object.get(
      "caption_entities",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let voice_duration : Int? = if object.get("voice_duration") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : InputMessageContentPlaceholder? = if object.get(
      "input_message_content",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    id,
    voice_url,
    title,
    caption,
    parse_mode,
    caption_entities,
    voice_duration,
    reply_markup,
    input_message_content,
  }
}

///|
/// Represents a link to a file. By default, this file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the file.
pub struct InlineQueryResultDocument {
  type_ : String
  id : String
  title : String
  document_url : String
  mime_type : String
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  description : String?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputMessageContentPlaceholder?
  thumbnail_url : String?
  thumbnail_width : Int?
  thumbnail_height : Int?
} derive(Debug, Eq)

///|
/// Creates a new [InlineQueryResultDocument].
pub fn InlineQueryResultDocument::new(
  id~ : String,
  title~ : String,
  document_url~ : String,
  mime_type~ : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  description? : String,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputMessageContentPlaceholder,
  thumbnail_url? : String,
  thumbnail_width? : Int,
  thumbnail_height? : Int,
) -> InlineQueryResultDocument {
  {
    type_: "document",
    id,
    title,
    document_url,
    mime_type,
    caption,
    parse_mode,
    caption_entities,
    description,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub impl ToJson for InlineQueryResultDocument with to_json(self) {
  let object : Map[String, Json] = {
    "type": self.type_.to_json(),
    "id": self.id.to_json(),
    "title": self.title.to_json(),
    "document_url": self.document_url.to_json(),
    "mime_type": self.mime_type.to_json(),
  }
  if self.caption is Some(v) {
    object["caption"] = v.to_json()
  }
  if self.parse_mode is Some(v) {
    object["parse_mode"] = v.to_json()
  }
  if self.caption_entities is Some(v) {
    object["caption_entities"] = v.to_json()
  }
  if self.description is Some(v) {
    object["description"] = v.to_json()
  }
  if self.reply_markup is Some(v) {
    object["reply_markup"] = v.to_json()
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = v.to_json()
  }
  if self.thumbnail_url is Some(v) {
    object["thumbnail_url"] = v.to_json()
  }
  if self.thumbnail_width is Some(v) {
    object["thumbnail_width"] = v.to_json()
  }
  if self.thumbnail_height is Some(v) {
    object["thumbnail_height"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for InlineQueryResultDocument with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InlineQueryResultDocument"),
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let title : String = @json.from_json(object["title"], path~)
  let document_url : String = @json.from_json(object["document_url"], path~)
  let mime_type : String = @json.from_json(object["mime_type"], path~)
  let caption : String? = if object.get("caption") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let parse_mode : String? = if object.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption_entities : Array[MessageEntity]? = if object.get(
      "caption_entities",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let description : String? = if object.get("description") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : InputMessageContentPlaceholder? = if object.get(
      "input_message_content",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_url : String? = if object.get("thumbnail_url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_width : Int? = if object.get("thumbnail_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_height : Int? = if object.get("thumbnail_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    id,
    title,
    document_url,
    mime_type,
    caption,
    parse_mode,
    caption_entities,
    description,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}
