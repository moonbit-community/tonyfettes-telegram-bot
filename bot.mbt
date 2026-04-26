///|
/// Represents a Telegram Bot API client.
pub struct Bot {
  token : String
  base_url : String
}

///|
/// Creates a new Bot.
pub fn Bot::new(token~ : String, base_url? : String) -> Bot {
  { token, base_url: base_url.unwrap_or("https://api.telegram.org") }
}

///|
fn Bot::api_url(self : Bot, api_method : String) -> String {
  "\{self.base_url}/bot\{self.token}/\{api_method}"
}

///|
fn[T : @json.FromJson] parse_api_response(
  data : &@io.Data,
) -> T raise TelegramError {
  let text = @encoding/utf8.decode(data.binary()) catch {
    error => raise TelegramError::InvalidUtf8(error)
  }
  let json = @json.parse(text) catch {
    error => raise TelegramError::InvalidJson(error)
  }
  guard json is Object(object) else {
    raise TelegramError::InvalidResponse(json)
  }
  let ok_json = match object.get("ok") {
    Some(value) => value
    None => raise TelegramError::InvalidResponse(json)
  }
  let ok : Bool = @json.from_json(ok_json) catch {
    _ => raise TelegramError::InvalidResponse(json)
  }
  if ok {
    let result = match object.get("result") {
      Some(value) => value
      None => raise TelegramError::InvalidResponse(json)
    }
    @json.from_json(result) catch {
      error => raise TelegramError::InvalidResult(result, error)
    }
  } else {
    let code_json = match object.get("error_code") {
      Some(value) => value
      None => raise TelegramError::InvalidResponse(json)
    }
    let desc_json = match object.get("description") {
      Some(value) => value
      None => raise TelegramError::InvalidResponse(json)
    }
    let code : Int = @json.from_json(code_json) catch {
      _ => raise TelegramError::InvalidResponse(json)
    }
    let desc : String = @json.from_json(desc_json) catch {
      _ => raise TelegramError::InvalidResponse(json)
    }
    raise TelegramError::ApiError(code~, description=desc)
  }
}

///|
/// A simple method for testing your bot's auth token.
/// Returns basic information about the bot in form of a User object.
pub async fn Bot::get_me(self : Bot) -> User raise TelegramError {
  let url = self.api_url("getMe")
  let (response, data) = telegram_http_get(url, headers={
    "Content-Type": "application/json",
  }) catch {
    error =>
      raise TelegramError::HttpError(code=0, body="Request failed: \{error}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body~)
  }
  parse_api_response(data)
}

///|
/// Use this method to send text messages.
/// On success, the sent Message is returned.
pub async fn Bot::send_message(
  self : Bot,
  chat_id~ : Int64,
  text~ : String,
  parse_mode? : String,
  disable_notification? : Bool,
  reply_to_message_id? : Int,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendMessage")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "text": text.to_json(),
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if reply_to_message_id is Some(v) {
    body["reply_to_message_id"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to receive incoming updates using long polling.
/// Returns an Array of Update objects.
pub async fn Bot::get_updates(
  self : Bot,
  offset? : Int,
  limit? : Int,
  timeout? : Int,
  allowed_updates? : Array[String],
) -> Array[Update] raise TelegramError {
  let url = self.api_url("getUpdates")
  let body : Map[String, Json] = {}
  if offset is Some(v) {
    body["offset"] = v.to_json()
  }
  if limit is Some(v) {
    body["limit"] = v.to_json()
  }
  if timeout is Some(v) {
    body["timeout"] = v.to_json()
  }
  if allowed_updates is Some(v) {
    body["allowed_updates"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to copy messages of any kind.
/// Returns the MessageId of the sent message on success.
pub async fn Bot::copy_message(
  self : Bot,
  chat_id~ : Int64,
  from_chat_id~ : Int64,
  message_id~ : Int,
  disable_notification? : Bool,
  reply_markup? : InlineKeyboardMarkup,
) -> MessageId raise TelegramError {
  let url = self.api_url("copyMessage")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "from_chat_id": int64_to_json(from_chat_id),
    "message_id": message_id.to_json(),
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to edit text and game messages.
/// On success, the edited Message is returned.
pub async fn Bot::edit_message_text(
  self : Bot,
  chat_id~ : Int64,
  message_id~ : Int,
  text~ : String,
  parse_mode? : String,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("editMessageText")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "message_id": message_id.to_json(),
    "text": text.to_json(),
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to edit only the reply markup of messages.
/// On success, the edited Message is returned.
pub async fn Bot::edit_message_reply_markup(
  self : Bot,
  chat_id~ : Int64,
  message_id~ : Int,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("editMessageReplyMarkup")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "message_id": message_id.to_json(),
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send answers to callback queries sent from inline keyboards.
/// On success, True is returned.
pub async fn Bot::answer_callback_query(
  self : Bot,
  callback_query_id~ : String,
  text? : String,
  show_alert? : Bool,
) -> Bool raise TelegramError {
  let url = self.api_url("answerCallbackQuery")
  let body : Map[String, Json] = {
    "callback_query_id": callback_query_id.to_json(),
  }
  if text is Some(v) {
    body["text"] = v.to_json()
  }
  if show_alert is Some(v) {
    body["show_alert"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to change the list of the bot's commands.
/// On success, True is returned.
pub async fn Bot::set_my_commands(
  self : Bot,
  commands~ : Array[BotCommand],
) -> Bool raise TelegramError {
  let url = self.api_url("setMyCommands")
  let body : Map[String, Json] = { "commands": ToJson::to_json(commands) }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send photos.
/// On success, the sent Message is returned.
pub async fn Bot::send_photo(
  self : Bot,
  chat_id~ : Int64,
  photo~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  has_spoiler? : Bool,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendPhoto")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "photo": photo.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if caption is Some(v) {
    body["caption"] = v.to_json()
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = v.to_json()
  }
  if caption_entities is Some(v) {
    body["caption_entities"] = ToJson::to_json(v)
  }
  if show_caption_above_media is Some(v) {
    body["show_caption_above_media"] = v.to_json()
  }
  if has_spoiler is Some(v) {
    body["has_spoiler"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = v.to_json()
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = v.to_json()
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send video files.
/// On success, the sent Message is returned.
pub async fn Bot::send_video(
  self : Bot,
  chat_id~ : Int64,
  video~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  duration? : Int,
  width? : Int,
  height? : Int,
  thumbnail? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  has_spoiler? : Bool,
  supports_streaming? : Bool,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendVideo")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "video": video.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if duration is Some(v) {
    body["duration"] = v.to_json()
  }
  if width is Some(v) {
    body["width"] = v.to_json()
  }
  if height is Some(v) {
    body["height"] = v.to_json()
  }
  if thumbnail is Some(v) {
    body["thumbnail"] = v.to_json()
  }
  if caption is Some(v) {
    body["caption"] = v.to_json()
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = v.to_json()
  }
  if caption_entities is Some(v) {
    body["caption_entities"] = ToJson::to_json(v)
  }
  if show_caption_above_media is Some(v) {
    body["show_caption_above_media"] = v.to_json()
  }
  if has_spoiler is Some(v) {
    body["has_spoiler"] = v.to_json()
  }
  if supports_streaming is Some(v) {
    body["supports_streaming"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = v.to_json()
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = v.to_json()
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send audio files, if you want Telegram clients to display
/// them in the music player. Your audio must be in the .MP3 or .M4A format.
/// On success, the sent Message is returned.
pub async fn Bot::send_audio(
  self : Bot,
  chat_id~ : Int64,
  audio~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  duration? : Int,
  performer? : String,
  title? : String,
  thumbnail? : String,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendAudio")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "audio": audio.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if caption is Some(v) {
    body["caption"] = v.to_json()
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = v.to_json()
  }
  if caption_entities is Some(v) {
    body["caption_entities"] = ToJson::to_json(v)
  }
  if duration is Some(v) {
    body["duration"] = v.to_json()
  }
  if performer is Some(v) {
    body["performer"] = v.to_json()
  }
  if title is Some(v) {
    body["title"] = v.to_json()
  }
  if thumbnail is Some(v) {
    body["thumbnail"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = v.to_json()
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = v.to_json()
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send general files.
/// On success, the sent Message is returned.
pub async fn Bot::send_document(
  self : Bot,
  chat_id~ : Int64,
  document~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  thumbnail? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  disable_content_type_detection? : Bool,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendDocument")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "document": document.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if thumbnail is Some(v) {
    body["thumbnail"] = v.to_json()
  }
  if caption is Some(v) {
    body["caption"] = v.to_json()
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = v.to_json()
  }
  if caption_entities is Some(v) {
    body["caption_entities"] = ToJson::to_json(v)
  }
  if disable_content_type_detection is Some(v) {
    body["disable_content_type_detection"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = v.to_json()
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = v.to_json()
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send voice messages.
/// On success, the sent Message is returned.
pub async fn Bot::send_voice(
  self : Bot,
  chat_id~ : Int64,
  voice~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  duration? : Int,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendVoice")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "voice": voice.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if caption is Some(v) {
    body["caption"] = v.to_json()
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = v.to_json()
  }
  if caption_entities is Some(v) {
    body["caption_entities"] = ToJson::to_json(v)
  }
  if duration is Some(v) {
    body["duration"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = v.to_json()
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = v.to_json()
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send video messages (video notes).
/// On success, the sent Message is returned.
pub async fn Bot::send_video_note(
  self : Bot,
  chat_id~ : Int64,
  video_note~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  duration? : Int,
  length? : Int,
  thumbnail? : String,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendVideoNote")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "video_note": video_note.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if duration is Some(v) {
    body["duration"] = v.to_json()
  }
  if length is Some(v) {
    body["length"] = v.to_json()
  }
  if thumbnail is Some(v) {
    body["thumbnail"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = v.to_json()
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = v.to_json()
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send animation files (GIF or H.264/MPEG-4 AVC video without sound).
/// On success, the sent Message is returned.
pub async fn Bot::send_animation(
  self : Bot,
  chat_id~ : Int64,
  animation~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  duration? : Int,
  width? : Int,
  height? : Int,
  thumbnail? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  has_spoiler? : Bool,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendAnimation")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "animation": animation.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if duration is Some(v) {
    body["duration"] = v.to_json()
  }
  if width is Some(v) {
    body["width"] = v.to_json()
  }
  if height is Some(v) {
    body["height"] = v.to_json()
  }
  if thumbnail is Some(v) {
    body["thumbnail"] = v.to_json()
  }
  if caption is Some(v) {
    body["caption"] = v.to_json()
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = v.to_json()
  }
  if caption_entities is Some(v) {
    body["caption_entities"] = ToJson::to_json(v)
  }
  if show_caption_above_media is Some(v) {
    body["show_caption_above_media"] = v.to_json()
  }
  if has_spoiler is Some(v) {
    body["has_spoiler"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = v.to_json()
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = v.to_json()
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send point on the map.
/// On success, the sent Message is returned.
pub async fn Bot::send_location(
  self : Bot,
  chat_id~ : Int64,
  latitude~ : Double,
  longitude~ : Double,
  business_connection_id? : String,
  message_thread_id? : Int,
  horizontal_accuracy? : Double,
  live_period? : Int,
  heading? : Int,
  proximity_alert_radius? : Int,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendLocation")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "latitude": latitude.to_json(),
    "longitude": longitude.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if horizontal_accuracy is Some(v) {
    body["horizontal_accuracy"] = v.to_json()
  }
  if live_period is Some(v) {
    body["live_period"] = v.to_json()
  }
  if heading is Some(v) {
    body["heading"] = v.to_json()
  }
  if proximity_alert_radius is Some(v) {
    body["proximity_alert_radius"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = v.to_json()
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = v.to_json()
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send information about a venue.
/// On success, the sent Message is returned.
pub async fn Bot::send_venue(
  self : Bot,
  chat_id~ : Int64,
  latitude~ : Double,
  longitude~ : Double,
  title~ : String,
  address~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  foursquare_id? : String,
  foursquare_type? : String,
  google_place_id? : String,
  google_place_type? : String,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendVenue")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "latitude": latitude.to_json(),
    "longitude": longitude.to_json(),
    "title": title.to_json(),
    "address": address.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if foursquare_id is Some(v) {
    body["foursquare_id"] = v.to_json()
  }
  if foursquare_type is Some(v) {
    body["foursquare_type"] = v.to_json()
  }
  if google_place_id is Some(v) {
    body["google_place_id"] = v.to_json()
  }
  if google_place_type is Some(v) {
    body["google_place_type"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = v.to_json()
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = v.to_json()
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send phone contacts.
/// On success, the sent Message is returned.
pub async fn Bot::send_contact(
  self : Bot,
  chat_id~ : Int64,
  phone_number~ : String,
  first_name~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  last_name? : String,
  vcard? : String,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendContact")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "phone_number": phone_number.to_json(),
    "first_name": first_name.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if last_name is Some(v) {
    body["last_name"] = v.to_json()
  }
  if vcard is Some(v) {
    body["vcard"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = v.to_json()
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = v.to_json()
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send a native poll.
/// On success, the sent Message is returned.
pub async fn Bot::send_poll(
  self : Bot,
  chat_id~ : Int64,
  question~ : String,
  options~ : Array[InputPollOption],
  business_connection_id? : String,
  message_thread_id? : Int,
  question_parse_mode? : String,
  question_entities? : Array[MessageEntity],
  is_anonymous? : Bool,
  type_? : String,
  allows_multiple_answers? : Bool,
  correct_option_id? : Int,
  explanation? : String,
  explanation_parse_mode? : String,
  explanation_entities? : Array[MessageEntity],
  open_period? : Int,
  close_date? : Int,
  is_closed? : Bool,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendPoll")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "question": question.to_json(),
    "options": ToJson::to_json(options),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if question_parse_mode is Some(v) {
    body["question_parse_mode"] = v.to_json()
  }
  if question_entities is Some(v) {
    body["question_entities"] = ToJson::to_json(v)
  }
  if is_anonymous is Some(v) {
    body["is_anonymous"] = v.to_json()
  }
  if type_ is Some(v) {
    body["type"] = v.to_json()
  }
  if allows_multiple_answers is Some(v) {
    body["allows_multiple_answers"] = v.to_json()
  }
  if correct_option_id is Some(v) {
    body["correct_option_id"] = v.to_json()
  }
  if explanation is Some(v) {
    body["explanation"] = v.to_json()
  }
  if explanation_parse_mode is Some(v) {
    body["explanation_parse_mode"] = v.to_json()
  }
  if explanation_entities is Some(v) {
    body["explanation_entities"] = ToJson::to_json(v)
  }
  if open_period is Some(v) {
    body["open_period"] = v.to_json()
  }
  if close_date is Some(v) {
    body["close_date"] = v.to_json()
  }
  if is_closed is Some(v) {
    body["is_closed"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = v.to_json()
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = v.to_json()
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send an animated emoji that will display a random value.
/// On success, the sent Message is returned.
pub async fn Bot::send_dice(
  self : Bot,
  chat_id~ : Int64,
  business_connection_id? : String,
  message_thread_id? : Int,
  emoji? : String,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendDice")
  let body : Map[String, Json] = { "chat_id": int64_to_json(chat_id) }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if emoji is Some(v) {
    body["emoji"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = v.to_json()
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = v.to_json()
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method when you need to tell the user that something is happening on the bot's side.
/// The status is set for 5 seconds or less (when a message arrives from your bot, Telegram clients clear its typing status).
/// On success, True is returned.
pub async fn Bot::send_chat_action(
  self : Bot,
  chat_id~ : Int64,
  action~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
) -> Bool raise TelegramError {
  let url = self.api_url("sendChatAction")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "action": action.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to edit live location messages.
/// On success, the edited Message is returned.
pub async fn Bot::edit_message_live_location(
  self : Bot,
  latitude~ : Double,
  longitude~ : Double,
  business_connection_id? : String,
  chat_id? : Int64,
  message_id? : Int,
  inline_message_id? : String,
  live_period? : Int,
  horizontal_accuracy? : Double,
  heading? : Int,
  proximity_alert_radius? : Int,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("editMessageLiveLocation")
  let body : Map[String, Json] = {
    "latitude": latitude.to_json(),
    "longitude": longitude.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if chat_id is Some(v) {
    body["chat_id"] = int64_to_json(v)
  }
  if message_id is Some(v) {
    body["message_id"] = v.to_json()
  }
  if inline_message_id is Some(v) {
    body["inline_message_id"] = v.to_json()
  }
  if live_period is Some(v) {
    body["live_period"] = v.to_json()
  }
  if horizontal_accuracy is Some(v) {
    body["horizontal_accuracy"] = v.to_json()
  }
  if heading is Some(v) {
    body["heading"] = v.to_json()
  }
  if proximity_alert_radius is Some(v) {
    body["proximity_alert_radius"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to stop updating a live location message before live_period expires.
/// On success, the edited Message is returned.
pub async fn Bot::stop_message_live_location(
  self : Bot,
  business_connection_id? : String,
  chat_id? : Int64,
  message_id? : Int,
  inline_message_id? : String,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("stopMessageLiveLocation")
  let body : Map[String, Json] = {}
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if chat_id is Some(v) {
    body["chat_id"] = int64_to_json(v)
  }
  if message_id is Some(v) {
    body["message_id"] = v.to_json()
  }
  if inline_message_id is Some(v) {
    body["inline_message_id"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to edit captions of messages.
/// On success, the edited Message is returned.
pub async fn Bot::edit_message_caption(
  self : Bot,
  business_connection_id? : String,
  chat_id? : Int64,
  message_id? : Int,
  inline_message_id? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("editMessageCaption")
  let body : Map[String, Json] = {}
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if chat_id is Some(v) {
    body["chat_id"] = int64_to_json(v)
  }
  if message_id is Some(v) {
    body["message_id"] = v.to_json()
  }
  if inline_message_id is Some(v) {
    body["inline_message_id"] = v.to_json()
  }
  if caption is Some(v) {
    body["caption"] = v.to_json()
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = v.to_json()
  }
  if caption_entities is Some(v) {
    body["caption_entities"] = ToJson::to_json(v)
  }
  if show_caption_above_media is Some(v) {
    body["show_caption_above_media"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to edit animation, audio, document, photo, or video messages.
/// On success, the edited Message is returned.
pub async fn Bot::edit_message_media(
  self : Bot,
  media~ : Json,
  business_connection_id? : String,
  chat_id? : Int64,
  message_id? : Int,
  inline_message_id? : String,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("editMessageMedia")
  let body : Map[String, Json] = { "media": media }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if chat_id is Some(v) {
    body["chat_id"] = int64_to_json(v)
  }
  if message_id is Some(v) {
    body["message_id"] = v.to_json()
  }
  if inline_message_id is Some(v) {
    body["inline_message_id"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to delete a message, including service messages.
/// Returns True on success.
pub async fn Bot::delete_message(
  self : Bot,
  chat_id~ : Int64,
  message_id~ : Int,
) -> Bool raise TelegramError {
  let url = self.api_url("deleteMessage")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "message_id": message_id.to_json(),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to delete multiple messages simultaneously.
/// Returns True on success.
pub async fn Bot::delete_messages(
  self : Bot,
  chat_id~ : Int64,
  message_ids~ : Array[Int],
) -> Bool raise TelegramError {
  let url = self.api_url("deleteMessages")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "message_ids": ToJson::to_json(message_ids),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to forward messages of any kind.
/// On success, the sent Message is returned.
pub async fn Bot::forward_message(
  self : Bot,
  chat_id~ : Int64,
  from_chat_id~ : Int64,
  message_id~ : Int,
  message_thread_id? : Int,
  disable_notification? : Bool,
  protect_content? : Bool,
) -> Message raise TelegramError {
  let url = self.api_url("forwardMessage")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "from_chat_id": int64_to_json(from_chat_id),
    "message_id": message_id.to_json(),
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to forward multiple messages of any kind.
/// On success, an Array of MessageId of the sent messages is returned.
pub async fn Bot::forward_messages(
  self : Bot,
  chat_id~ : Int64,
  from_chat_id~ : Int64,
  message_ids~ : Array[Int],
  message_thread_id? : Int,
  disable_notification? : Bool,
  protect_content? : Bool,
) -> Array[MessageId] raise TelegramError {
  let url = self.api_url("forwardMessages")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "from_chat_id": int64_to_json(from_chat_id),
    "message_ids": ToJson::to_json(message_ids),
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to ban a user in a group, a supergroup or a channel.
/// In the case of supergroups and channels, the user will not be able to return
/// to the chat on their own using invite links, etc., unless unbanned first.
/// Returns True on success.
pub async fn Bot::ban_chat_member(
  self : Bot,
  chat_id~ : Int64,
  user_id~ : Int64,
  until_date? : Int,
  revoke_messages? : Bool,
) -> Bool raise TelegramError {
  let url = self.api_url("banChatMember")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "user_id": int64_to_json(user_id),
  }
  if until_date is Some(v) {
    body["until_date"] = v.to_json()
  }
  if revoke_messages is Some(v) {
    body["revoke_messages"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to unban a previously banned user in a supergroup or channel.
/// The user will not return to the group or channel automatically, but will be
/// able to join via link, etc. The bot must be an administrator for this to work.
/// Returns True on success.
pub async fn Bot::unban_chat_member(
  self : Bot,
  chat_id~ : Int64,
  user_id~ : Int64,
  only_if_banned? : Bool,
) -> Bool raise TelegramError {
  let url = self.api_url("unbanChatMember")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "user_id": int64_to_json(user_id),
  }
  if only_if_banned is Some(v) {
    body["only_if_banned"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to restrict a user in a supergroup.
/// The bot must be an administrator in the supergroup for this to work
/// and must have the appropriate administrator rights.
/// Returns True on success.
pub async fn Bot::restrict_chat_member(
  self : Bot,
  chat_id~ : Int64,
  user_id~ : Int64,
  permissions~ : ChatPermissions,
  use_independent_chat_permissions? : Bool,
  until_date? : Int,
) -> Bool raise TelegramError {
  let url = self.api_url("restrictChatMember")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "user_id": int64_to_json(user_id),
    "permissions": permissions.to_json(),
  }
  if use_independent_chat_permissions is Some(v) {
    body["use_independent_chat_permissions"] = v.to_json()
  }
  if until_date is Some(v) {
    body["until_date"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to promote or demote a user in a supergroup or a channel.
/// The bot must be an administrator in the chat for this to work
/// and must have the appropriate administrator rights.
/// Returns True on success.
pub async fn Bot::promote_chat_member(
  self : Bot,
  chat_id~ : Int64,
  user_id~ : Int64,
  is_anonymous? : Bool,
  can_manage_chat? : Bool,
  can_delete_messages? : Bool,
  can_manage_video_chats? : Bool,
  can_restrict_members? : Bool,
  can_promote_members? : Bool,
  can_change_info? : Bool,
  can_invite_users? : Bool,
  can_post_stories? : Bool,
  can_edit_stories? : Bool,
  can_delete_stories? : Bool,
  can_post_messages? : Bool,
  can_edit_messages? : Bool,
  can_pin_messages? : Bool,
  can_manage_topics? : Bool,
) -> Bool raise TelegramError {
  let url = self.api_url("promoteChatMember")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "user_id": int64_to_json(user_id),
  }
  if is_anonymous is Some(v) {
    body["is_anonymous"] = v.to_json()
  }
  if can_manage_chat is Some(v) {
    body["can_manage_chat"] = v.to_json()
  }
  if can_delete_messages is Some(v) {
    body["can_delete_messages"] = v.to_json()
  }
  if can_manage_video_chats is Some(v) {
    body["can_manage_video_chats"] = v.to_json()
  }
  if can_restrict_members is Some(v) {
    body["can_restrict_members"] = v.to_json()
  }
  if can_promote_members is Some(v) {
    body["can_promote_members"] = v.to_json()
  }
  if can_change_info is Some(v) {
    body["can_change_info"] = v.to_json()
  }
  if can_invite_users is Some(v) {
    body["can_invite_users"] = v.to_json()
  }
  if can_post_stories is Some(v) {
    body["can_post_stories"] = v.to_json()
  }
  if can_edit_stories is Some(v) {
    body["can_edit_stories"] = v.to_json()
  }
  if can_delete_stories is Some(v) {
    body["can_delete_stories"] = v.to_json()
  }
  if can_post_messages is Some(v) {
    body["can_post_messages"] = v.to_json()
  }
  if can_edit_messages is Some(v) {
    body["can_edit_messages"] = v.to_json()
  }
  if can_pin_messages is Some(v) {
    body["can_pin_messages"] = v.to_json()
  }
  if can_manage_topics is Some(v) {
    body["can_manage_topics"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to set a custom title for an administrator in a supergroup
/// promoted by the bot. Returns True on success.
pub async fn Bot::set_chat_administrator_custom_title(
  self : Bot,
  chat_id~ : Int64,
  user_id~ : Int64,
  custom_title~ : String,
) -> Bool raise TelegramError {
  let url = self.api_url("setChatAdministratorCustomTitle")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "user_id": int64_to_json(user_id),
    "custom_title": custom_title.to_json(),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to generate a new primary invite link for a chat.
/// Any previously generated primary link is revoked.
/// Returns the new invite link as String on success.
pub async fn Bot::export_chat_invite_link(
  self : Bot,
  chat_id~ : Int64,
) -> String raise TelegramError {
  let url = self.api_url("exportChatInviteLink")
  let body : Map[String, Json] = { "chat_id": int64_to_json(chat_id) }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to create an additional invite link for a chat.
/// Returns the new invite link as ChatInviteLink object.
pub async fn Bot::create_chat_invite_link(
  self : Bot,
  chat_id~ : Int64,
  name? : String,
  expire_date? : Int,
  member_limit? : Int,
  creates_join_request? : Bool,
) -> Json raise TelegramError {
  let url = self.api_url("createChatInviteLink")
  let body : Map[String, Json] = { "chat_id": int64_to_json(chat_id) }
  if name is Some(v) {
    body["name"] = v.to_json()
  }
  if expire_date is Some(v) {
    body["expire_date"] = v.to_json()
  }
  if member_limit is Some(v) {
    body["member_limit"] = v.to_json()
  }
  if creates_join_request is Some(v) {
    body["creates_join_request"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to edit a non-primary invite link created by the bot.
/// Returns the edited invite link as ChatInviteLink object.
pub async fn Bot::edit_chat_invite_link(
  self : Bot,
  chat_id~ : Int64,
  invite_link~ : String,
  name? : String,
  expire_date? : Int,
  member_limit? : Int,
  creates_join_request? : Bool,
) -> Json raise TelegramError {
  let url = self.api_url("editChatInviteLink")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "invite_link": invite_link.to_json(),
  }
  if name is Some(v) {
    body["name"] = v.to_json()
  }
  if expire_date is Some(v) {
    body["expire_date"] = v.to_json()
  }
  if member_limit is Some(v) {
    body["member_limit"] = v.to_json()
  }
  if creates_join_request is Some(v) {
    body["creates_join_request"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to revoke an invite link created by the bot.
/// Returns the revoked invite link as ChatInviteLink object.
pub async fn Bot::revoke_chat_invite_link(
  self : Bot,
  chat_id~ : Int64,
  invite_link~ : String,
) -> Json raise TelegramError {
  let url = self.api_url("revokeChatInviteLink")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "invite_link": invite_link.to_json(),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to approve a chat join request.
/// Returns True on success.
pub async fn Bot::approve_chat_join_request(
  self : Bot,
  chat_id~ : Int64,
  user_id~ : Int64,
) -> Bool raise TelegramError {
  let url = self.api_url("approveChatJoinRequest")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "user_id": int64_to_json(user_id),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to decline a chat join request.
/// Returns True on success.
pub async fn Bot::decline_chat_join_request(
  self : Bot,
  chat_id~ : Int64,
  user_id~ : Int64,
) -> Bool raise TelegramError {
  let url = self.api_url("declineChatJoinRequest")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "user_id": int64_to_json(user_id),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to set default chat permissions for all members.
/// The bot must be an administrator in the group or a supergroup for this to work
/// and must have the can_restrict_members administrator rights.
/// Returns True on success.
pub async fn Bot::set_chat_permissions(
  self : Bot,
  chat_id~ : Int64,
  permissions~ : ChatPermissions,
  use_independent_chat_permissions? : Bool,
) -> Bool raise TelegramError {
  let url = self.api_url("setChatPermissions")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "permissions": permissions.to_json(),
  }
  if use_independent_chat_permissions is Some(v) {
    body["use_independent_chat_permissions"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to set a new profile photo for the chat.
/// Photos can't be changed for private chats.
/// The bot must be an administrator in the chat for this to work
/// and must have the appropriate administrator rights.
/// Returns True on success.
pub async fn Bot::set_chat_photo(
  self : Bot,
  chat_id~ : Int64,
  photo~ : String,
) -> Bool raise TelegramError {
  let url = self.api_url("setChatPhoto")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "photo": photo.to_json(),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to delete a chat photo.
/// Photos can't be changed for private chats.
/// The bot must be an administrator in the chat for this to work
/// and must have the appropriate administrator rights.
/// Returns True on success.
pub async fn Bot::delete_chat_photo(
  self : Bot,
  chat_id~ : Int64,
) -> Bool raise TelegramError {
  let url = self.api_url("deleteChatPhoto")
  let body : Map[String, Json] = { "chat_id": int64_to_json(chat_id) }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to change the title of a chat.
/// Titles can't be changed for private chats.
/// The bot must be an administrator in the chat for this to work
/// and must have the appropriate administrator rights.
/// Returns True on success.
pub async fn Bot::set_chat_title(
  self : Bot,
  chat_id~ : Int64,
  title~ : String,
) -> Bool raise TelegramError {
  let url = self.api_url("setChatTitle")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "title": title.to_json(),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to change the description of a group, a supergroup or a channel.
/// The bot must be an administrator in the chat for this to work
/// and must have the appropriate administrator rights.
/// Returns True on success.
pub async fn Bot::set_chat_description(
  self : Bot,
  chat_id~ : Int64,
  description? : String,
) -> Bool raise TelegramError {
  let url = self.api_url("setChatDescription")
  let body : Map[String, Json] = { "chat_id": int64_to_json(chat_id) }
  if description is Some(v) {
    body["description"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to add a message to the list of pinned messages in a chat.
/// If the chat is not a private chat, the bot must be an administrator in the chat
/// for this to work and must have the 'can_pin_messages' administrator right
/// in a supergroup or 'can_edit_messages' administrator right in a channel.
/// Returns True on success.
pub async fn Bot::pin_chat_message(
  self : Bot,
  chat_id~ : Int64,
  message_id~ : Int,
  business_connection_id? : String,
  disable_notification? : Bool,
) -> Bool raise TelegramError {
  let url = self.api_url("pinChatMessage")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "message_id": message_id.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to remove a message from the list of pinned messages in a chat.
/// If the chat is not a private chat, the bot must be an administrator in the chat
/// for this to work and must have the 'can_pin_messages' administrator right
/// in a supergroup or 'can_edit_messages' administrator right in a channel.
/// Returns True on success.
pub async fn Bot::unpin_chat_message(
  self : Bot,
  chat_id~ : Int64,
  business_connection_id? : String,
  message_id? : Int,
) -> Bool raise TelegramError {
  let url = self.api_url("unpinChatMessage")
  let body : Map[String, Json] = { "chat_id": int64_to_json(chat_id) }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_id is Some(v) {
    body["message_id"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to clear the list of pinned messages in a chat.
/// If the chat is not a private chat, the bot must be an administrator in the chat
/// for this to work and must have the 'can_pin_messages' administrator right
/// in a supergroup or 'can_edit_messages' administrator right in a channel.
/// Returns True on success.
pub async fn Bot::unpin_all_chat_messages(
  self : Bot,
  chat_id~ : Int64,
) -> Bool raise TelegramError {
  let url = self.api_url("unpinAllChatMessages")
  let body : Map[String, Json] = { "chat_id": int64_to_json(chat_id) }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method for your bot to leave a group, supergroup or channel.
/// Returns True on success.
pub async fn Bot::leave_chat(
  self : Bot,
  chat_id~ : Int64,
) -> Bool raise TelegramError {
  let url = self.api_url("leaveChat")
  let body : Map[String, Json] = { "chat_id": int64_to_json(chat_id) }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get up to date information about the chat.
/// Returns a ChatFullInfo object on success.
pub async fn Bot::get_chat(
  self : Bot,
  chat_id~ : Int64,
) -> ChatFullInfo raise TelegramError {
  let url = self.api_url("getChat")
  let body : Map[String, Json] = { "chat_id": int64_to_json(chat_id) }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send static .WEBP, animated .TGS, or video .WEBM stickers.
/// On success, the sent Message is returned.
pub async fn Bot::send_sticker(
  self : Bot,
  chat_id~ : Int64,
  sticker~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  emoji? : String,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendSticker")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "sticker": sticker.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if emoji is Some(v) {
    body["emoji"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = v.to_json()
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = v.to_json()
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get information about custom emoji stickers by their identifiers.
/// Returns an Array of Sticker objects.
pub async fn Bot::get_custom_emoji_stickers(
  self : Bot,
  custom_emoji_ids~ : Array[String],
) -> Array[Sticker] raise TelegramError {
  let url = self.api_url("getCustomEmojiStickers")
  let body : Map[String, Json] = {
    "custom_emoji_ids": custom_emoji_ids.to_json(),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get a sticker set.
/// On success, a StickerSet object is returned.
pub async fn Bot::get_sticker_set(
  self : Bot,
  name~ : String,
) -> StickerSet raise TelegramError {
  let url = self.api_url("getStickerSet")
  let body : Map[String, Json] = { "name": name.to_json() }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to upload a file with a sticker for later use in
/// the createNewStickerSet, addStickerToSet, or replaceStickerInSet methods.
/// Returns the uploaded File on success.
pub async fn Bot::upload_sticker_file(
  self : Bot,
  user_id~ : Int64,
  sticker~ : String,
  sticker_format~ : String,
) -> File raise TelegramError {
  let url = self.api_url("uploadStickerFile")
  let body : Map[String, Json] = {
    "user_id": int64_to_json(user_id),
    "sticker": sticker.to_json(),
    "sticker_format": sticker_format.to_json(),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to delete a sticker from a set created by the bot.
/// Returns True on success.
pub async fn Bot::delete_sticker_from_set(
  self : Bot,
  sticker~ : String,
) -> Bool raise TelegramError {
  let url = self.api_url("deleteStickerFromSet")
  let body : Map[String, Json] = { "sticker": sticker.to_json() }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to move a sticker in a set created by the bot to a specific position.
/// Returns True on success.
pub async fn Bot::set_sticker_position_in_set(
  self : Bot,
  sticker~ : String,
  position~ : Int,
) -> Bool raise TelegramError {
  let url = self.api_url("setStickerPositionInSet")
  let body : Map[String, Json] = {
    "sticker": sticker.to_json(),
    "position": position.to_json(),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to change the list of emoji assigned to a regular or custom emoji sticker.
/// The sticker must belong to a sticker set created by the bot.
/// Returns True on success.
pub async fn Bot::set_sticker_emoji_list(
  self : Bot,
  sticker~ : String,
  emoji_list~ : Array[String],
) -> Bool raise TelegramError {
  let url = self.api_url("setStickerEmojiList")
  let body : Map[String, Json] = {
    "sticker": sticker.to_json(),
    "emoji_list": ToJson::to_json(emoji_list),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to delete a sticker set that was created by the bot.
/// Returns True on success.
pub async fn Bot::delete_sticker_set(
  self : Bot,
  name~ : String,
) -> Bool raise TelegramError {
  let url = self.api_url("deleteStickerSet")
  let body : Map[String, Json] = { "name": name.to_json() }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send answers to an inline query.
/// On success, True is returned.
/// No more than 50 results per query are allowed.
pub async fn Bot::answer_inline_query(
  self : Bot,
  inline_query_id~ : String,
  results~ : Array[Json],
  cache_time? : Int,
  is_personal? : Bool,
  next_offset? : String,
  button? : InlineQueryResultsButton,
) -> Bool raise TelegramError {
  let url = self.api_url("answerInlineQuery")
  let body : Map[String, Json] = {
    "inline_query_id": inline_query_id.to_json(),
    "results": ToJson::to_json(results),
  }
  if cache_time is Some(v) {
    body["cache_time"] = v.to_json()
  }
  if is_personal is Some(v) {
    body["is_personal"] = v.to_json()
  }
  if next_offset is Some(v) {
    body["next_offset"] = v.to_json()
  }
  if button is Some(v) {
    body["button"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to set the result of an interaction with a Web App and send a corresponding message on behalf of the user to the chat from which the query originated.
/// On success, a SentWebAppMessage object is returned.
pub async fn Bot::answer_web_app_query(
  self : Bot,
  web_app_query_id~ : String,
  result~ : Json,
) -> Json raise TelegramError {
  let url = self.api_url("answerWebAppQuery")
  let body : Map[String, Json] = {
    "web_app_query_id": web_app_query_id.to_json(),
    "result": result,
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send a game.
/// On success, the sent Message is returned.
pub async fn Bot::send_game(
  self : Bot,
  chat_id~ : Int64,
  game_short_name~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendGame")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "game_short_name": game_short_name.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = v.to_json()
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = v.to_json()
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to set the score of the specified user in a game message.
/// On success, if the message is not an inline message, the Message is returned, otherwise True is returned.
/// Returns an error, if the new score is not greater than the user's current score in the chat and force is False.
pub async fn Bot::set_game_score(
  self : Bot,
  user_id~ : Int64,
  score~ : Int,
  force? : Bool,
  disable_edit_message? : Bool,
  chat_id? : Int64,
  message_id? : Int,
  inline_message_id? : String,
) -> Json raise TelegramError {
  let url = self.api_url("setGameScore")
  let body : Map[String, Json] = {
    "user_id": int64_to_json(user_id),
    "score": score.to_json(),
  }
  if force is Some(v) {
    body["force"] = v.to_json()
  }
  if disable_edit_message is Some(v) {
    body["disable_edit_message"] = v.to_json()
  }
  if chat_id is Some(v) {
    body["chat_id"] = int64_to_json(v)
  }
  if message_id is Some(v) {
    body["message_id"] = v.to_json()
  }
  if inline_message_id is Some(v) {
    body["inline_message_id"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get data for high score tables.
/// Will return the score of the specified user and several of their neighbors in a game.
/// Returns an Array of GameHighScore objects.
pub async fn Bot::get_game_high_scores(
  self : Bot,
  user_id~ : Int64,
  chat_id? : Int64,
  message_id? : Int,
  inline_message_id? : String,
) -> Array[Json] raise TelegramError {
  let url = self.api_url("getGameHighScores")
  let body : Map[String, Json] = { "user_id": int64_to_json(user_id) }
  if chat_id is Some(v) {
    body["chat_id"] = int64_to_json(v)
  }
  if message_id is Some(v) {
    body["message_id"] = v.to_json()
  }
  if inline_message_id is Some(v) {
    body["inline_message_id"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send invoices.
/// On success, the sent Message is returned.
pub async fn Bot::send_invoice(
  self : Bot,
  chat_id~ : Int64,
  title~ : String,
  description~ : String,
  payload~ : String,
  currency~ : String,
  prices~ : Array[LabeledPrice],
  provider_token? : String,
  message_thread_id? : Int,
  max_tip_amount? : Int,
  suggested_tip_amounts? : Array[Int],
  start_parameter? : String,
  provider_data? : String,
  photo_url? : String,
  photo_size? : Int,
  photo_width? : Int,
  photo_height? : Int,
  need_name? : Bool,
  need_phone_number? : Bool,
  need_email? : Bool,
  need_shipping_address? : Bool,
  send_phone_number_to_provider? : Bool,
  send_email_to_provider? : Bool,
  is_flexible? : Bool,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendInvoice")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "title": title.to_json(),
    "description": description.to_json(),
    "payload": payload.to_json(),
    "currency": currency.to_json(),
    "prices": prices.to_json(),
  }
  if provider_token is Some(v) {
    body["provider_token"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if max_tip_amount is Some(v) {
    body["max_tip_amount"] = v.to_json()
  }
  if suggested_tip_amounts is Some(v) {
    body["suggested_tip_amounts"] = v.to_json()
  }
  if start_parameter is Some(v) {
    body["start_parameter"] = v.to_json()
  }
  if provider_data is Some(v) {
    body["provider_data"] = v.to_json()
  }
  if photo_url is Some(v) {
    body["photo_url"] = v.to_json()
  }
  if photo_size is Some(v) {
    body["photo_size"] = v.to_json()
  }
  if photo_width is Some(v) {
    body["photo_width"] = v.to_json()
  }
  if photo_height is Some(v) {
    body["photo_height"] = v.to_json()
  }
  if need_name is Some(v) {
    body["need_name"] = v.to_json()
  }
  if need_phone_number is Some(v) {
    body["need_phone_number"] = v.to_json()
  }
  if need_email is Some(v) {
    body["need_email"] = v.to_json()
  }
  if need_shipping_address is Some(v) {
    body["need_shipping_address"] = v.to_json()
  }
  if send_phone_number_to_provider is Some(v) {
    body["send_phone_number_to_provider"] = v.to_json()
  }
  if send_email_to_provider is Some(v) {
    body["send_email_to_provider"] = v.to_json()
  }
  if is_flexible is Some(v) {
    body["is_flexible"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if protect_content is Some(v) {
    body["protect_content"] = v.to_json()
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = v.to_json()
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = v.to_json()
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = v.to_json()
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to create a link for an invoice.
/// Returns the created invoice link as String on success.
pub async fn Bot::create_invoice_link(
  self : Bot,
  title~ : String,
  description~ : String,
  payload~ : String,
  currency~ : String,
  prices~ : Array[LabeledPrice],
  provider_token? : String,
  max_tip_amount? : Int,
  suggested_tip_amounts? : Array[Int],
  provider_data? : String,
  photo_url? : String,
  photo_size? : Int,
  photo_width? : Int,
  photo_height? : Int,
  need_name? : Bool,
  need_phone_number? : Bool,
  need_email? : Bool,
  need_shipping_address? : Bool,
  send_phone_number_to_provider? : Bool,
  send_email_to_provider? : Bool,
  is_flexible? : Bool,
  subscription_period? : Int,
  business_connection_id? : String,
) -> String raise TelegramError {
  let url = self.api_url("createInvoiceLink")
  let body : Map[String, Json] = {
    "title": title.to_json(),
    "description": description.to_json(),
    "payload": payload.to_json(),
    "currency": currency.to_json(),
    "prices": prices.to_json(),
  }
  if provider_token is Some(v) {
    body["provider_token"] = v.to_json()
  }
  if max_tip_amount is Some(v) {
    body["max_tip_amount"] = v.to_json()
  }
  if suggested_tip_amounts is Some(v) {
    body["suggested_tip_amounts"] = v.to_json()
  }
  if provider_data is Some(v) {
    body["provider_data"] = v.to_json()
  }
  if photo_url is Some(v) {
    body["photo_url"] = v.to_json()
  }
  if photo_size is Some(v) {
    body["photo_size"] = v.to_json()
  }
  if photo_width is Some(v) {
    body["photo_width"] = v.to_json()
  }
  if photo_height is Some(v) {
    body["photo_height"] = v.to_json()
  }
  if need_name is Some(v) {
    body["need_name"] = v.to_json()
  }
  if need_phone_number is Some(v) {
    body["need_phone_number"] = v.to_json()
  }
  if need_email is Some(v) {
    body["need_email"] = v.to_json()
  }
  if need_shipping_address is Some(v) {
    body["need_shipping_address"] = v.to_json()
  }
  if send_phone_number_to_provider is Some(v) {
    body["send_phone_number_to_provider"] = v.to_json()
  }
  if send_email_to_provider is Some(v) {
    body["send_email_to_provider"] = v.to_json()
  }
  if is_flexible is Some(v) {
    body["is_flexible"] = v.to_json()
  }
  if subscription_period is Some(v) {
    body["subscription_period"] = v.to_json()
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// If you sent an invoice requesting a shipping address and the parameter is_flexible was specified,
/// the Bot API will send an Update with a shipping_query field to the bot.
/// Use this method to reply to shipping queries.
/// On success, True is returned.
pub async fn Bot::answer_shipping_query(
  self : Bot,
  shipping_query_id~ : String,
  ok~ : Bool,
  shipping_options? : Array[ShippingOption],
  error_message? : String,
) -> Bool raise TelegramError {
  let url = self.api_url("answerShippingQuery")
  let body : Map[String, Json] = {
    "shipping_query_id": shipping_query_id.to_json(),
    "ok": ok.to_json(),
  }
  if shipping_options is Some(v) {
    body["shipping_options"] = v.to_json()
  }
  if error_message is Some(v) {
    body["error_message"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Once the user has confirmed their payment and shipping details,
/// the Bot API sends the final confirmation in the form of an Update with the field pre_checkout_query.
/// Use this method to respond to such pre-checkout queries.
/// On success, True is returned.
/// Note: The Bot API must receive an answer within 10 seconds after the pre-checkout query was sent.
pub async fn Bot::answer_pre_checkout_query(
  self : Bot,
  pre_checkout_query_id~ : String,
  ok~ : Bool,
  error_message? : String,
) -> Bool raise TelegramError {
  let url = self.api_url("answerPreCheckoutQuery")
  let body : Map[String, Json] = {
    "pre_checkout_query_id": pre_checkout_query_id.to_json(),
    "ok": ok.to_json(),
  }
  if error_message is Some(v) {
    body["error_message"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to specify a URL and receive incoming updates via an outgoing webhook.
/// Returns True on success.
pub async fn Bot::set_webhook(
  self : Bot,
  url~ : String,
  certificate? : String,
  ip_address? : String,
  max_connections? : Int,
  allowed_updates? : Array[String],
  drop_pending_updates? : Bool,
  secret_token? : String,
) -> Bool raise TelegramError {
  let api_url = self.api_url("setWebhook")
  let body : Map[String, Json] = { "url": url.to_json() }
  if certificate is Some(v) {
    body["certificate"] = v.to_json()
  }
  if ip_address is Some(v) {
    body["ip_address"] = v.to_json()
  }
  if max_connections is Some(v) {
    body["max_connections"] = v.to_json()
  }
  if allowed_updates is Some(v) {
    body["allowed_updates"] = ToJson::to_json(v)
  }
  if drop_pending_updates is Some(v) {
    body["drop_pending_updates"] = v.to_json()
  }
  if secret_token is Some(v) {
    body["secret_token"] = v.to_json()
  }
  let (response, data) = telegram_http_post(
    api_url,
    body.to_json().stringify(),
    headers={ "Content-Type": "application/json" },
  ) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to remove webhook integration if you decide to switch back to getUpdates.
/// Returns True on success.
pub async fn Bot::delete_webhook(
  self : Bot,
  drop_pending_updates? : Bool,
) -> Bool raise TelegramError {
  let url = self.api_url("deleteWebhook")
  let body : Map[String, Json] = {}
  if drop_pending_updates is Some(v) {
    body["drop_pending_updates"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get current webhook status.
/// On success, returns a WebhookInfo object.
pub async fn Bot::get_webhook_info(
  self : Bot,
) -> WebhookInfo raise TelegramError {
  let url = self.api_url("getWebhookInfo")
  let (response, data) = telegram_http_get(url, headers={
    "Content-Type": "application/json",
  }) catch {
    error =>
      raise TelegramError::HttpError(code=0, body="Request failed: \{error}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body~)
  }
  parse_api_response(data)
}

///|
/// Use this method to get basic information about a file and prepare it for downloading.
/// On success, a File object is returned.
pub async fn Bot::get_file(
  self : Bot,
  file_id~ : String,
) -> File raise TelegramError {
  let url = self.api_url("getFile")
  let body : Map[String, Json] = { "file_id": file_id.to_json() }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get a list of profile pictures for a user.
/// Returns a UserProfilePhotos object.
pub async fn Bot::get_user_profile_photos(
  self : Bot,
  user_id~ : Int64,
  offset? : Int,
  limit? : Int,
) -> Json raise TelegramError {
  let url = self.api_url("getUserProfilePhotos")
  let body : Map[String, Json] = { "user_id": int64_to_json(user_id) }
  if offset is Some(v) {
    body["offset"] = v.to_json()
  }
  if limit is Some(v) {
    body["limit"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get custom emoji stickers, which can be used as a forum topic icon by any user.
/// Returns an Array of Sticker objects.
pub async fn Bot::get_forum_topic_icon_stickers(
  self : Bot,
) -> Array[Sticker] raise TelegramError {
  let url = self.api_url("getForumTopicIconStickers")
  let (response, data) = telegram_http_get(url, headers={
    "Content-Type": "application/json",
  }) catch {
    error =>
      raise TelegramError::HttpError(code=0, body="Request failed: \{error}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body~)
  }
  parse_api_response(data)
}

///|
/// Use this method to create a topic in a forum supergroup chat.
/// Returns information about the created topic as a ForumTopic object.
pub async fn Bot::create_forum_topic(
  self : Bot,
  chat_id~ : Int64,
  name~ : String,
  icon_color? : Int,
  icon_custom_emoji_id? : String,
) -> Json raise TelegramError {
  let url = self.api_url("createForumTopic")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "name": name.to_json(),
  }
  if icon_color is Some(v) {
    body["icon_color"] = v.to_json()
  }
  if icon_custom_emoji_id is Some(v) {
    body["icon_custom_emoji_id"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to edit name and icon of a topic in a forum supergroup chat.
/// Returns True on success.
pub async fn Bot::edit_forum_topic(
  self : Bot,
  chat_id~ : Int64,
  message_thread_id~ : Int,
  name? : String,
  icon_custom_emoji_id? : String,
) -> Bool raise TelegramError {
  let url = self.api_url("editForumTopic")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "message_thread_id": message_thread_id.to_json(),
  }
  if name is Some(v) {
    body["name"] = v.to_json()
  }
  if icon_custom_emoji_id is Some(v) {
    body["icon_custom_emoji_id"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to close an open topic in a forum supergroup chat.
/// Returns True on success.
pub async fn Bot::close_forum_topic(
  self : Bot,
  chat_id~ : Int64,
  message_thread_id~ : Int,
) -> Bool raise TelegramError {
  let url = self.api_url("closeForumTopic")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "message_thread_id": message_thread_id.to_json(),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to reopen a closed topic in a forum supergroup chat.
/// Returns True on success.
pub async fn Bot::reopen_forum_topic(
  self : Bot,
  chat_id~ : Int64,
  message_thread_id~ : Int,
) -> Bool raise TelegramError {
  let url = self.api_url("reopenForumTopic")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "message_thread_id": message_thread_id.to_json(),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to delete a forum topic along with all its messages in a forum supergroup chat.
/// Returns True on success.
pub async fn Bot::delete_forum_topic(
  self : Bot,
  chat_id~ : Int64,
  message_thread_id~ : Int,
) -> Bool raise TelegramError {
  let url = self.api_url("deleteForumTopic")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "message_thread_id": message_thread_id.to_json(),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to clear the list of pinned messages in a forum topic.
/// Returns True on success.
pub async fn Bot::unpin_all_forum_topic_messages(
  self : Bot,
  chat_id~ : Int64,
  message_thread_id~ : Int,
) -> Bool raise TelegramError {
  let url = self.api_url("unpinAllForumTopicMessages")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "message_thread_id": message_thread_id.to_json(),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to edit the name of the 'General' topic in a forum supergroup chat.
/// Returns True on success.
pub async fn Bot::edit_general_forum_topic(
  self : Bot,
  chat_id~ : Int64,
  name~ : String,
) -> Bool raise TelegramError {
  let url = self.api_url("editGeneralForumTopic")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "name": name.to_json(),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to close an open 'General' topic in a forum supergroup chat.
/// Returns True on success.
pub async fn Bot::close_general_forum_topic(
  self : Bot,
  chat_id~ : Int64,
) -> Bool raise TelegramError {
  let url = self.api_url("closeGeneralForumTopic")
  let body : Map[String, Json] = { "chat_id": int64_to_json(chat_id) }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to reopen a closed 'General' topic in a forum supergroup chat.
/// Returns True on success.
pub async fn Bot::reopen_general_forum_topic(
  self : Bot,
  chat_id~ : Int64,
) -> Bool raise TelegramError {
  let url = self.api_url("reopenGeneralForumTopic")
  let body : Map[String, Json] = { "chat_id": int64_to_json(chat_id) }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to hide the 'General' topic in a forum supergroup chat.
/// Returns True on success.
pub async fn Bot::hide_general_forum_topic(
  self : Bot,
  chat_id~ : Int64,
) -> Bool raise TelegramError {
  let url = self.api_url("hideGeneralForumTopic")
  let body : Map[String, Json] = { "chat_id": int64_to_json(chat_id) }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to unhide the 'General' topic in a forum supergroup chat.
/// Returns True on success.
pub async fn Bot::unhide_general_forum_topic(
  self : Bot,
  chat_id~ : Int64,
) -> Bool raise TelegramError {
  let url = self.api_url("unhideGeneralForumTopic")
  let body : Map[String, Json] = { "chat_id": int64_to_json(chat_id) }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to delete the list of the bot's commands for the given scope and user language.
/// After deletion, higher level commands will be shown to affected users.
/// Returns True on success.
pub async fn Bot::delete_my_commands(
  self : Bot,
  scope? : Json,
  language_code? : String,
) -> Bool raise TelegramError {
  let url = self.api_url("deleteMyCommands")
  let body : Map[String, Json] = {}
  if scope is Some(v) {
    body["scope"] = v
  }
  if language_code is Some(v) {
    body["language_code"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get the current list of the bot's commands for the given scope and user language.
/// Returns an Array of BotCommand objects.
/// If commands aren't set, an empty list is returned.
pub async fn Bot::get_my_commands(
  self : Bot,
  scope? : Json,
  language_code? : String,
) -> Array[BotCommand] raise TelegramError {
  let url = self.api_url("getMyCommands")
  let body : Map[String, Json] = {}
  if scope is Some(v) {
    body["scope"] = v
  }
  if language_code is Some(v) {
    body["language_code"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to change the bot's name.
/// Returns True on success.
pub async fn Bot::set_my_name(
  self : Bot,
  name? : String,
  language_code? : String,
) -> Bool raise TelegramError {
  let url = self.api_url("setMyName")
  let body : Map[String, Json] = {}
  if name is Some(v) {
    body["name"] = v.to_json()
  }
  if language_code is Some(v) {
    body["language_code"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get the current bot name for the given user language.
/// Returns BotName on success.
pub async fn Bot::get_my_name(
  self : Bot,
  language_code? : String,
) -> Json raise TelegramError {
  let url = self.api_url("getMyName")
  let body : Map[String, Json] = {}
  if language_code is Some(v) {
    body["language_code"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to change the bot's description, which is shown in the chat with the bot if the chat is empty.
/// Returns True on success.
pub async fn Bot::set_my_description(
  self : Bot,
  description? : String,
  language_code? : String,
) -> Bool raise TelegramError {
  let url = self.api_url("setMyDescription")
  let body : Map[String, Json] = {}
  if description is Some(v) {
    body["description"] = v.to_json()
  }
  if language_code is Some(v) {
    body["language_code"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get the current bot description for the given user language.
/// Returns BotDescription on success.
pub async fn Bot::get_my_description(
  self : Bot,
  language_code? : String,
) -> Json raise TelegramError {
  let url = self.api_url("getMyDescription")
  let body : Map[String, Json] = {}
  if language_code is Some(v) {
    body["language_code"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to change the bot's short description, which is shown on the bot's profile page
/// and is sent together with the link when users share the bot.
/// Returns True on success.
pub async fn Bot::set_my_short_description(
  self : Bot,
  short_description? : String,
  language_code? : String,
) -> Bool raise TelegramError {
  let url = self.api_url("setMyShortDescription")
  let body : Map[String, Json] = {}
  if short_description is Some(v) {
    body["short_description"] = v.to_json()
  }
  if language_code is Some(v) {
    body["language_code"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get the current bot short description for the given user language.
/// Returns BotShortDescription on success.
pub async fn Bot::get_my_short_description(
  self : Bot,
  language_code? : String,
) -> Json raise TelegramError {
  let url = self.api_url("getMyShortDescription")
  let body : Map[String, Json] = {}
  if language_code is Some(v) {
    body["language_code"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to change the bot's menu button in a private chat, or the default menu button.
/// Returns True on success.
pub async fn Bot::set_chat_menu_button(
  self : Bot,
  chat_id? : Int64,
  menu_button? : Json,
) -> Bool raise TelegramError {
  let url = self.api_url("setChatMenuButton")
  let body : Map[String, Json] = {}
  if chat_id is Some(v) {
    body["chat_id"] = int64_to_json(v)
  }
  if menu_button is Some(v) {
    body["menu_button"] = v
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get the current value of the bot's menu button in a private chat, or the default menu button.
/// Returns MenuButton on success.
pub async fn Bot::get_chat_menu_button(
  self : Bot,
  chat_id? : Int64,
) -> Json raise TelegramError {
  let url = self.api_url("getChatMenuButton")
  let body : Map[String, Json] = {}
  if chat_id is Some(v) {
    body["chat_id"] = int64_to_json(v)
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get a list of administrators in a chat, which aren't bots.
/// Returns an Array of ChatMember objects.
pub async fn Bot::get_chat_administrators(
  self : Bot,
  chat_id~ : ChatId,
) -> Array[Json] raise TelegramError {
  let url = self.api_url("getChatAdministrators")
  let body : Map[String, Json] = { "chat_id": chat_id.to_json() }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get the number of members in a chat.
/// Returns Int on success.
pub async fn Bot::get_chat_member_count(
  self : Bot,
  chat_id~ : ChatId,
) -> Int raise TelegramError {
  let url = self.api_url("getChatMemberCount")
  let body : Map[String, Json] = { "chat_id": chat_id.to_json() }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get information about a member of a chat.
/// The method is only guaranteed to work for other users if the bot is an administrator in the chat.
/// Returns a ChatMember object on success.
pub async fn Bot::get_chat_member(
  self : Bot,
  chat_id~ : ChatId,
  user_id~ : Int64,
) -> Json raise TelegramError {
  let url = self.api_url("getChatMember")
  let body : Map[String, Json] = {
    "chat_id": chat_id.to_json(),
    "user_id": int64_to_json(user_id),
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send a checklist.
/// On success, sent Message is returned.
pub async fn Bot::send_checklist(
  self : Bot,
  business_connection_id? : String,
  chat_id~ : Int64,
  message_thread_id? : Int,
  checklist~ : InputChecklist,
) -> Message raise TelegramError {
  let url = self.api_url("sendChecklist")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "checklist": checklist.to_json(),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to send draft text messages.
/// This method allows streaming partial messages.
/// On success, MessageId of the sent message is returned.
pub async fn Bot::send_message_draft(
  self : Bot,
  chat_id~ : ChatId,
  text~ : String,
  message_thread_id? : Int,
  direct_messages_topic_id? : Int,
  business_connection_id? : String,
  parse_mode? : String,
  entities? : Array[MessageEntity],
  link_preview_options? : LinkPreviewOptions,
  disable_web_page_preview? : Bool,
) -> MessageId raise TelegramError {
  let url = self.api_url("sendMessageDraft")
  let body : Map[String, Json] = {
    "chat_id": chat_id.to_json(),
    "text": text.to_json(),
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if direct_messages_topic_id is Some(v) {
    body["direct_messages_topic_id"] = v.to_json()
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = v.to_json()
  }
  if entities is Some(v) {
    body["entities"] = ToJson::to_json(v)
  }
  if link_preview_options is Some(v) {
    body["link_preview_options"] = v.to_json()
  }
  if disable_web_page_preview is Some(v) {
    body["disable_web_page_preview"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to edit a checklist attached to a message.
/// On success, edited Message is returned.
pub async fn Bot::edit_message_checklist(
  self : Bot,
  business_connection_id? : String,
  chat_id? : Int64,
  message_id? : Int,
  inline_message_id? : String,
  reply_to_message_id? : Int,
  checklist~ : InputChecklist,
) -> Message raise TelegramError {
  let url = self.api_url("editMessageChecklist")
  let body : Map[String, Json] = { "checklist": checklist.to_json() }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if chat_id is Some(v) {
    body["chat_id"] = int64_to_json(v)
  }
  if message_id is Some(v) {
    body["message_id"] = v.to_json()
  }
  if inline_message_id is Some(v) {
    body["inline_message_id"] = v.to_json()
  }
  if reply_to_message_id is Some(v) {
    body["reply_to_message_id"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get list of gifts that can be sent by user.
/// Returns Gifts on success.
pub async fn Bot::get_user_gifts(
  self : Bot,
  offset? : Int,
  limit? : Int,
) -> Gifts raise TelegramError {
  let url = self.api_url("getUserGifts")
  let body : Map[String, Json] = {}
  if offset is Some(v) {
    body["offset"] = v.to_json()
  }
  if limit is Some(v) {
    body["limit"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get list of gifts that were sent to user.
/// Returns Gifts on success.
pub async fn Bot::get_chat_gifts(
  self : Bot,
  chat_id~ : ChatId,
  offset? : Int,
  limit? : Int,
) -> Gifts raise TelegramError {
  let url = self.api_url("getChatGifts")
  let body : Map[String, Json] = { "chat_id": chat_id.to_json() }
  if offset is Some(v) {
    body["offset"] = v.to_json()
  }
  if limit is Some(v) {
    body["limit"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to get number of Telegram Stars that can be spent by bot.
/// Returns StarBalance on success.
pub async fn Bot::get_my_star_balance(
  self : Bot,
) -> StarBalance raise TelegramError {
  let url = self.api_url("getMyStarBalance")
  let body : Map[String, Json] = {}
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to approve a suggested post.
/// Returns True on success.
pub async fn Bot::approve_suggested_post(
  self : Bot,
  chat_id~ : Int64,
  user_id~ : Int64,
  inline_message_id? : String,
  message_id? : Int,
) -> Bool raise TelegramError {
  let url = self.api_url("approveSuggestedPost")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "user_id": int64_to_json(user_id),
  }
  if inline_message_id is Some(v) {
    body["inline_message_id"] = v.to_json()
  }
  if message_id is Some(v) {
    body["message_id"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to decline a suggested post.
/// Returns True on success.
pub async fn Bot::decline_suggested_post(
  self : Bot,
  chat_id~ : Int64,
  user_id~ : Int64,
  inline_message_id? : String,
  message_id? : Int,
) -> Bool raise TelegramError {
  let url = self.api_url("declineSuggestedPost")
  let body : Map[String, Json] = {
    "chat_id": int64_to_json(chat_id),
    "user_id": int64_to_json(user_id),
  }
  if inline_message_id is Some(v) {
    body["inline_message_id"] = v.to_json()
  }
  if message_id is Some(v) {
    body["message_id"] = v.to_json()
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to repost stories across business accounts.
/// On success, MessageId of the reposted story is returned.
pub async fn Bot::repost_story(
  self : Bot,
  chat_id~ : ChatId,
  from_chat_id~ : ChatId,
  story_id~ : Int,
  message_thread_id? : Int,
  direct_messages_topic_id? : Int,
  business_connection_id? : String,
  text? : String,
  parse_mode? : String,
  entities? : Array[MessageEntity],
) -> MessageId raise TelegramError {
  let url = self.api_url("repostStory")
  let body : Map[String, Json] = {
    "chat_id": chat_id.to_json(),
    "from_chat_id": from_chat_id.to_json(),
    "story_id": story_id.to_json(),
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = v.to_json()
  }
  if direct_messages_topic_id is Some(v) {
    body["direct_messages_topic_id"] = v.to_json()
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = v.to_json()
  }
  if text is Some(v) {
    body["text"] = v.to_json()
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = v.to_json()
  }
  if entities is Some(v) {
    body["entities"] = ToJson::to_json(v)
  }
  let (response, data) = telegram_http_post(url, body.to_json().stringify(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let bytes = data.binary()
    let body_text = @encoding/utf8.decode(bytes) catch {
      _ =>
        raise TelegramError::HttpError(
          code=response.code,
          body=@encoding/utf8.decode_lossy(bytes),
        )
    }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}
