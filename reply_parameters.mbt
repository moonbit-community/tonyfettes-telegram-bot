///|
/// Unique identifier for the target chat or username of the target channel.
pub(all) enum ChatId {
  Id(Int64)
  Username(String)
} derive(Show, Eq)

///|
pub impl ToJson for ChatId with to_json(self) {
  match self {
    Id(id) => int64_to_json(id)
    Username(username) => username.to_json()
  }
}

///|
pub impl @json.FromJson for ChatId with from_json(json, path) {
  match json {
    Number(n, ..) => Id(n.to_int64())
    String(s) => Username(s)
    _ =>
      raise @json.JsonDecodeError(
        (path, "Expected number or string for ChatId"),
      )
  }
}

///|
/// Describes reply parameters for the message that is being sent.
pub struct ReplyParameters {
  message_id : Int
  chat_id : ChatId?
  allow_sending_without_reply : Bool?
  quote : String?
  quote_parse_mode : String?
  quote_entities : Array[MessageEntity]?
  quote_position : Int?
} derive(Show, Eq)

///|
/// Creates a new [ReplyParameters].
pub fn ReplyParameters::new(
  message_id~ : Int,
  chat_id? : ChatId,
  allow_sending_without_reply? : Bool,
  quote? : String,
  quote_parse_mode? : String,
  quote_entities? : Array[MessageEntity],
  quote_position? : Int,
) -> ReplyParameters {
  {
    message_id,
    chat_id,
    allow_sending_without_reply,
    quote,
    quote_parse_mode,
    quote_entities,
    quote_position,
  }
}

///|
pub impl ToJson for ReplyParameters with to_json(self) {
  let object : Map[String, Json] = { "message_id": self.message_id.to_json() }
  if self.chat_id is Some(v) {
    object["chat_id"] = v.to_json()
  }
  if self.allow_sending_without_reply is Some(v) {
    object["allow_sending_without_reply"] = v.to_json()
  }
  if self.quote is Some(v) {
    object["quote"] = v.to_json()
  }
  if self.quote_parse_mode is Some(v) {
    object["quote_parse_mode"] = v.to_json()
  }
  if self.quote_entities is Some(v) {
    object["quote_entities"] = v.to_json()
  }
  if self.quote_position is Some(v) {
    object["quote_position"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for ReplyParameters with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for ReplyParameters"))
  }
  let message_id : Int = @json.from_json(object["message_id"], path~)
  let chat_id : ChatId? = if object.get("chat_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let allow_sending_without_reply : Bool? = if object.get(
      "allow_sending_without_reply",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let quote : String? = if object.get("quote") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let quote_parse_mode : String? = if object.get("quote_parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let quote_entities : Array[MessageEntity]? = if object.get("quote_entities")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let quote_position : Int? = if object.get("quote_position") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    message_id,
    chat_id,
    allow_sending_without_reply,
    quote,
    quote_parse_mode,
    quote_entities,
    quote_position,
  }
}

///|
/// Placeholder for the MessageOrigin type.
pub struct MessageOriginPlaceholder {
  type_ : String
  date : Int
} derive(Show, Eq)

///|
/// Creates a new [MessageOriginPlaceholder].
pub fn MessageOriginPlaceholder::new(
  type_~ : String,
  date~ : Int,
) -> MessageOriginPlaceholder {
  { type_, date }
}

///|
pub impl ToJson for MessageOriginPlaceholder with to_json(self) {
  let object : Map[String, Json] = {
    "type": self.type_.to_json(),
    "date": self.date.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for MessageOriginPlaceholder with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for MessageOriginPlaceholder"),
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let date : Int = @json.from_json(object["date"], path~)
  { type_, date }
}

///|
/// Placeholder for the LinkPreviewOptions type.
pub struct LinkPreviewPlaceholder {
  is_disabled : Bool?
} derive(Show, Eq)

///|
/// Creates a new [LinkPreviewPlaceholder].
pub fn LinkPreviewPlaceholder::new(
  is_disabled? : Bool,
) -> LinkPreviewPlaceholder {
  { is_disabled, }
}

///|
pub impl ToJson for LinkPreviewPlaceholder with to_json(self) {
  let object : Map[String, Json] = {}
  if self.is_disabled is Some(v) {
    object["is_disabled"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for LinkPreviewPlaceholder with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for LinkPreviewPlaceholder"),
    )
  }
  let is_disabled : Bool? = if object.get("is_disabled") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { is_disabled, }
}

///|
/// Placeholder for the Game type.
pub struct GamePlaceholder {
  title : String
  description : String
} derive(Show, Eq)

///|
/// Creates a new [GamePlaceholder].
pub fn GamePlaceholder::new(
  title~ : String,
  description~ : String,
) -> GamePlaceholder {
  { title, description }
}

///|
pub impl ToJson for GamePlaceholder with to_json(self) {
  let object : Map[String, Json] = {
    "title": self.title.to_json(),
    "description": self.description.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for GamePlaceholder with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for GamePlaceholder"))
  }
  let title : String = @json.from_json(object["title"], path~)
  let description : String = @json.from_json(object["description"], path~)
  { title, description }
}

///|
/// This object contains information about a message that is being replied to, which may come from another chat or forum topic.
pub struct ExternalReplyInfo {
  origin : MessageOriginPlaceholder
  chat : Chat?
  message_id : Int?
  link_preview_options : LinkPreviewPlaceholder?
  animation : Animation?
  audio : Audio?
  document : Document?
  paid_media : PaidMediaInfo?
  photo : Array[PhotoSize]?
  sticker : Sticker?
  story : Story?
  video : Video?
  video_note : VideoNote?
  voice : Voice?
  has_media_spoiler : Bool?
  contact : Contact?
  dice : Dice?
  game : GamePlaceholder?
  giveaway : Giveaway?
  giveaway_winners : GiveawayWinners?
  invoice : Invoice?
  location : Location?
  poll : Poll?
  venue : Venue?
} derive(Show, Eq)

///|
/// Creates a new [ExternalReplyInfo].
pub fn ExternalReplyInfo::new(
  origin~ : MessageOriginPlaceholder,
  chat? : Chat,
  message_id? : Int,
  link_preview_options? : LinkPreviewPlaceholder,
  animation? : Animation,
  audio? : Audio,
  document? : Document,
  paid_media? : PaidMediaInfo,
  photo? : Array[PhotoSize],
  sticker? : Sticker,
  story? : Story,
  video? : Video,
  video_note? : VideoNote,
  voice? : Voice,
  has_media_spoiler? : Bool,
  contact? : Contact,
  dice? : Dice,
  game? : GamePlaceholder,
  giveaway? : Giveaway,
  giveaway_winners? : GiveawayWinners,
  invoice? : Invoice,
  location? : Location,
  poll? : Poll,
  venue? : Venue,
) -> ExternalReplyInfo {
  {
    origin,
    chat,
    message_id,
    link_preview_options,
    animation,
    audio,
    document,
    paid_media,
    photo,
    sticker,
    story,
    video,
    video_note,
    voice,
    has_media_spoiler,
    contact,
    dice,
    game,
    giveaway,
    giveaway_winners,
    invoice,
    location,
    poll,
    venue,
  }
}

///|
pub impl ToJson for ExternalReplyInfo with to_json(self) {
  let object : Map[String, Json] = { "origin": self.origin.to_json() }
  if self.chat is Some(v) {
    object["chat"] = v.to_json()
  }
  if self.message_id is Some(v) {
    object["message_id"] = v.to_json()
  }
  if self.link_preview_options is Some(v) {
    object["link_preview_options"] = v.to_json()
  }
  if self.animation is Some(v) {
    object["animation"] = v.to_json()
  }
  if self.audio is Some(v) {
    object["audio"] = v.to_json()
  }
  if self.document is Some(v) {
    object["document"] = v.to_json()
  }
  if self.paid_media is Some(v) {
    object["paid_media"] = v.to_json()
  }
  if self.photo is Some(v) {
    object["photo"] = v.to_json()
  }
  if self.sticker is Some(v) {
    object["sticker"] = v.to_json()
  }
  if self.story is Some(v) {
    object["story"] = v.to_json()
  }
  if self.video is Some(v) {
    object["video"] = v.to_json()
  }
  if self.video_note is Some(v) {
    object["video_note"] = v.to_json()
  }
  if self.voice is Some(v) {
    object["voice"] = v.to_json()
  }
  if self.has_media_spoiler is Some(v) {
    object["has_media_spoiler"] = v.to_json()
  }
  if self.contact is Some(v) {
    object["contact"] = v.to_json()
  }
  if self.dice is Some(v) {
    object["dice"] = v.to_json()
  }
  if self.game is Some(v) {
    object["game"] = v.to_json()
  }
  if self.giveaway is Some(v) {
    object["giveaway"] = v.to_json()
  }
  if self.giveaway_winners is Some(v) {
    object["giveaway_winners"] = v.to_json()
  }
  if self.invoice is Some(v) {
    object["invoice"] = v.to_json()
  }
  if self.location is Some(v) {
    object["location"] = v.to_json()
  }
  if self.poll is Some(v) {
    object["poll"] = v.to_json()
  }
  if self.venue is Some(v) {
    object["venue"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for ExternalReplyInfo with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for ExternalReplyInfo"))
  }
  let origin : MessageOriginPlaceholder = @json.from_json(
    object["origin"],
    path~,
  )
  let chat : Chat? = if object.get("chat") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let message_id : Int? = if object.get("message_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let link_preview_options : LinkPreviewPlaceholder? = if object.get(
      "link_preview_options",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let animation : Animation? = if object.get("animation") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let audio : Audio? = if object.get("audio") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let document : Document? = if object.get("document") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let paid_media : PaidMediaInfo? = if object.get("paid_media") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let photo : Array[PhotoSize]? = if object.get("photo") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let sticker : Sticker? = if object.get("sticker") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let story : Story? = if object.get("story") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let video : Video? = if object.get("video") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let video_note : VideoNote? = if object.get("video_note") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let voice : Voice? = if object.get("voice") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let has_media_spoiler : Bool? = if object.get("has_media_spoiler") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let contact : Contact? = if object.get("contact") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let dice : Dice? = if object.get("dice") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let game : GamePlaceholder? = if object.get("game") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let giveaway : Giveaway? = if object.get("giveaway") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let giveaway_winners : GiveawayWinners? = if object.get("giveaway_winners")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let invoice : Invoice? = if object.get("invoice") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let location : Location? = if object.get("location") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let poll : Poll? = if object.get("poll") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let venue : Venue? = if object.get("venue") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    origin,
    chat,
    message_id,
    link_preview_options,
    animation,
    audio,
    document,
    paid_media,
    photo,
    sticker,
    story,
    video,
    video_note,
    voice,
    has_media_spoiler,
    contact,
    dice,
    game,
    giveaway,
    giveaway_winners,
    invoice,
    location,
    poll,
    venue,
  }
}
