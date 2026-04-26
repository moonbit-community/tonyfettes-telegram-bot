///|
/// Simplified input message content for cached inline query results.
pub struct CachedInputMessageContent {
  message_text : String
} derive(Debug, Eq)

///|
/// Creates a new [CachedInputMessageContent].
pub fn CachedInputMessageContent::new(
  message_text~ : String,
) -> CachedInputMessageContent {
  { message_text, }
}

///|
pub impl ToJson for CachedInputMessageContent with to_json(self) {
  let object : Map[String, Json] = {
    "message_text": self.message_text.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for CachedInputMessageContent with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for CachedInputMessageContent"),
    )
  }
  let message_text : String = @json.from_json(object["message_text"], path~)
  { message_text, }
}

///|
/// Represents a link to a photo stored on the Telegram servers. By default, this photo will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the photo.
pub struct InlineQueryResultCachedPhoto {
  type_ : String
  id : String
  photo_file_id : String
  title : String?
  description : String?
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  show_caption_above_media : Bool?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Debug, Eq)

///|
/// Creates a new [InlineQueryResultCachedPhoto].
pub fn InlineQueryResultCachedPhoto::new(
  id~ : String,
  photo_file_id~ : String,
  title? : String,
  description? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedPhoto {
  {
    type_: "photo",
    id,
    photo_file_id,
    title,
    description,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl ToJson for InlineQueryResultCachedPhoto with to_json(self) {
  let object : Map[String, Json] = {
    "type": self.type_.to_json(),
    "id": self.id.to_json(),
    "photo_file_id": self.photo_file_id.to_json(),
  }
  if self.title is Some(v) {
    object["title"] = v.to_json()
  }
  if self.description is Some(v) {
    object["description"] = v.to_json()
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
  if self.show_caption_above_media is Some(v) {
    object["show_caption_above_media"] = v.to_json()
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
pub impl @json.FromJson for InlineQueryResultCachedPhoto with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InlineQueryResultCachedPhoto"),
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let photo_file_id : String = @json.from_json(object["photo_file_id"], path~)
  let title : String? = if object.get("title") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let description : String? = if object.get("description") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
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
  let show_caption_above_media : Bool? = if object.get(
      "show_caption_above_media",
    )
    is Some(v) {
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
  let input_message_content : CachedInputMessageContent? = if object.get(
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
    photo_file_id,
    title,
    description,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
/// Represents a link to an animated GIF file stored on the Telegram servers. By default, this animated GIF file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the animation.
pub struct InlineQueryResultCachedGif {
  type_ : String
  id : String
  gif_file_id : String
  title : String?
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  show_caption_above_media : Bool?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Debug, Eq)

///|
/// Creates a new [InlineQueryResultCachedGif].
pub fn InlineQueryResultCachedGif::new(
  id~ : String,
  gif_file_id~ : String,
  title? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedGif {
  {
    type_: "gif",
    id,
    gif_file_id,
    title,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl ToJson for InlineQueryResultCachedGif with to_json(self) {
  let object : Map[String, Json] = {
    "type": self.type_.to_json(),
    "id": self.id.to_json(),
    "gif_file_id": self.gif_file_id.to_json(),
  }
  if self.title is Some(v) {
    object["title"] = v.to_json()
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
  if self.show_caption_above_media is Some(v) {
    object["show_caption_above_media"] = v.to_json()
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
pub impl @json.FromJson for InlineQueryResultCachedGif with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InlineQueryResultCachedGif"),
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let gif_file_id : String = @json.from_json(object["gif_file_id"], path~)
  let title : String? = if object.get("title") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
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
  let show_caption_above_media : Bool? = if object.get(
      "show_caption_above_media",
    )
    is Some(v) {
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
  let input_message_content : CachedInputMessageContent? = if object.get(
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
    gif_file_id,
    title,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
/// Represents a link to a video animation (H.264/MPEG-4 AVC video without sound) stored on the Telegram servers. By default, this animated MPEG-4 file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the animation.
pub struct InlineQueryResultCachedMpeg4Gif {
  type_ : String
  id : String
  mpeg4_file_id : String
  title : String?
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  show_caption_above_media : Bool?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Debug, Eq)

///|
/// Creates a new [InlineQueryResultCachedMpeg4Gif].
pub fn InlineQueryResultCachedMpeg4Gif::new(
  id~ : String,
  mpeg4_file_id~ : String,
  title? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedMpeg4Gif {
  {
    type_: "mpeg4_gif",
    id,
    mpeg4_file_id,
    title,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl ToJson for InlineQueryResultCachedMpeg4Gif with to_json(self) {
  let object : Map[String, Json] = {
    "type": self.type_.to_json(),
    "id": self.id.to_json(),
    "mpeg4_file_id": self.mpeg4_file_id.to_json(),
  }
  if self.title is Some(v) {
    object["title"] = v.to_json()
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
  if self.show_caption_above_media is Some(v) {
    object["show_caption_above_media"] = v.to_json()
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
pub impl @json.FromJson for InlineQueryResultCachedMpeg4Gif with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InlineQueryResultCachedMpeg4Gif"),
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let mpeg4_file_id : String = @json.from_json(object["mpeg4_file_id"], path~)
  let title : String? = if object.get("title") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
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
  let show_caption_above_media : Bool? = if object.get(
      "show_caption_above_media",
    )
    is Some(v) {
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
  let input_message_content : CachedInputMessageContent? = if object.get(
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
    mpeg4_file_id,
    title,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
/// Represents a link to a sticker stored on the Telegram servers. By default, this sticker will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the sticker.
pub struct InlineQueryResultCachedSticker {
  type_ : String
  id : String
  sticker_file_id : String
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Debug, Eq)

///|
/// Creates a new [InlineQueryResultCachedSticker].
pub fn InlineQueryResultCachedSticker::new(
  id~ : String,
  sticker_file_id~ : String,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedSticker {
  { type_: "sticker", id, sticker_file_id, reply_markup, input_message_content }
}

///|
pub impl ToJson for InlineQueryResultCachedSticker with to_json(self) {
  let object : Map[String, Json] = {
    "type": self.type_.to_json(),
    "id": self.id.to_json(),
    "sticker_file_id": self.sticker_file_id.to_json(),
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
pub impl @json.FromJson for InlineQueryResultCachedSticker with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InlineQueryResultCachedSticker"),
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let sticker_file_id : String = @json.from_json(
    object["sticker_file_id"],
    path~,
  )
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : CachedInputMessageContent? = if object.get(
      "input_message_content",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { type_, id, sticker_file_id, reply_markup, input_message_content }
}

///|
/// Represents a link to a file stored on the Telegram servers. By default, this file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the file.
pub struct InlineQueryResultCachedDocument {
  type_ : String
  id : String
  title : String
  document_file_id : String
  description : String?
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Debug, Eq)

///|
/// Creates a new [InlineQueryResultCachedDocument].
pub fn InlineQueryResultCachedDocument::new(
  id~ : String,
  title~ : String,
  document_file_id~ : String,
  description? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedDocument {
  {
    type_: "document",
    id,
    title,
    document_file_id,
    description,
    caption,
    parse_mode,
    caption_entities,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl ToJson for InlineQueryResultCachedDocument with to_json(self) {
  let object : Map[String, Json] = {
    "type": self.type_.to_json(),
    "id": self.id.to_json(),
    "title": self.title.to_json(),
    "document_file_id": self.document_file_id.to_json(),
  }
  if self.description is Some(v) {
    object["description"] = v.to_json()
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
  if self.reply_markup is Some(v) {
    object["reply_markup"] = v.to_json()
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for InlineQueryResultCachedDocument with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InlineQueryResultCachedDocument"),
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let title : String = @json.from_json(object["title"], path~)
  let document_file_id : String = @json.from_json(
    object["document_file_id"],
    path~,
  )
  let description : String? = if object.get("description") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
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
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : CachedInputMessageContent? = if object.get(
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
    title,
    document_file_id,
    description,
    caption,
    parse_mode,
    caption_entities,
    reply_markup,
    input_message_content,
  }
}

///|
/// Represents a link to a video file stored on the Telegram servers. By default, this video file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the video.
pub struct InlineQueryResultCachedVideo {
  type_ : String
  id : String
  video_file_id : String
  title : String
  description : String?
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  show_caption_above_media : Bool?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Debug, Eq)

///|
/// Creates a new [InlineQueryResultCachedVideo].
pub fn InlineQueryResultCachedVideo::new(
  id~ : String,
  video_file_id~ : String,
  title~ : String,
  description? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedVideo {
  {
    type_: "video",
    id,
    video_file_id,
    title,
    description,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl ToJson for InlineQueryResultCachedVideo with to_json(self) {
  let object : Map[String, Json] = {
    "type": self.type_.to_json(),
    "id": self.id.to_json(),
    "video_file_id": self.video_file_id.to_json(),
    "title": self.title.to_json(),
  }
  if self.description is Some(v) {
    object["description"] = v.to_json()
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
  if self.show_caption_above_media is Some(v) {
    object["show_caption_above_media"] = v.to_json()
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
pub impl @json.FromJson for InlineQueryResultCachedVideo with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InlineQueryResultCachedVideo"),
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let video_file_id : String = @json.from_json(object["video_file_id"], path~)
  let title : String = @json.from_json(object["title"], path~)
  let description : String? = if object.get("description") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
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
  let show_caption_above_media : Bool? = if object.get(
      "show_caption_above_media",
    )
    is Some(v) {
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
  let input_message_content : CachedInputMessageContent? = if object.get(
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
    video_file_id,
    title,
    description,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
/// Represents a link to a voice message stored on the Telegram servers. By default, this voice message will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the voice message.
pub struct InlineQueryResultCachedVoice {
  type_ : String
  id : String
  voice_file_id : String
  title : String
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Debug, Eq)

///|
/// Creates a new [InlineQueryResultCachedVoice].
pub fn InlineQueryResultCachedVoice::new(
  id~ : String,
  voice_file_id~ : String,
  title~ : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedVoice {
  {
    type_: "voice",
    id,
    voice_file_id,
    title,
    caption,
    parse_mode,
    caption_entities,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl ToJson for InlineQueryResultCachedVoice with to_json(self) {
  let object : Map[String, Json] = {
    "type": self.type_.to_json(),
    "id": self.id.to_json(),
    "voice_file_id": self.voice_file_id.to_json(),
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
  if self.reply_markup is Some(v) {
    object["reply_markup"] = v.to_json()
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for InlineQueryResultCachedVoice with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InlineQueryResultCachedVoice"),
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let voice_file_id : String = @json.from_json(object["voice_file_id"], path~)
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
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : CachedInputMessageContent? = if object.get(
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
    voice_file_id,
    title,
    caption,
    parse_mode,
    caption_entities,
    reply_markup,
    input_message_content,
  }
}

///|
/// Represents a link to an MP3 audio file stored on the Telegram servers. By default, this audio file will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the audio.
pub struct InlineQueryResultCachedAudio {
  type_ : String
  id : String
  audio_file_id : String
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Debug, Eq)

///|
/// Creates a new [InlineQueryResultCachedAudio].
pub fn InlineQueryResultCachedAudio::new(
  id~ : String,
  audio_file_id~ : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedAudio {
  {
    type_: "audio",
    id,
    audio_file_id,
    caption,
    parse_mode,
    caption_entities,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl ToJson for InlineQueryResultCachedAudio with to_json(self) {
  let object : Map[String, Json] = {
    "type": self.type_.to_json(),
    "id": self.id.to_json(),
    "audio_file_id": self.audio_file_id.to_json(),
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
  if self.reply_markup is Some(v) {
    object["reply_markup"] = v.to_json()
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for InlineQueryResultCachedAudio with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InlineQueryResultCachedAudio"),
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let audio_file_id : String = @json.from_json(object["audio_file_id"], path~)
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
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : CachedInputMessageContent? = if object.get(
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
    audio_file_id,
    caption,
    parse_mode,
    caption_entities,
    reply_markup,
    input_message_content,
  }
}
