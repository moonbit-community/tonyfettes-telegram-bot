///|
/// Represents an incoming inline query. When the user sends an empty query, your bot could return some default or trending results.
pub struct InlineQuery {
  id : String
  from : User
  query : String
  offset : String
  chat_type : String?
  location : Location?
} derive(Debug, Eq)

///|
/// Creates a new [InlineQuery].
pub fn InlineQuery::new(
  id~ : String,
  from~ : User,
  query~ : String,
  offset~ : String,
  chat_type? : String,
  location? : Location,
) -> InlineQuery {
  { id, from, query, offset, chat_type, location }
}

///|
pub impl ToJson for InlineQuery with to_json(self) {
  let object : Map[String, Json] = {
    "id": self.id.to_json(),
    "from": self.from.to_json(),
    "query": self.query.to_json(),
    "offset": self.offset.to_json(),
  }
  if self.chat_type is Some(v) {
    object["chat_type"] = v.to_json()
  }
  if self.location is Some(v) {
    object["location"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for InlineQuery with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for InlineQuery"))
  }
  let id : String = @json.from_json(object["id"], path~)
  let from : User = @json.from_json(object["from"], path~)
  let query : String = @json.from_json(object["query"], path~)
  let offset : String = @json.from_json(object["offset"], path~)
  let chat_type : String? = if object.get("chat_type") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let location : Location? = if object.get("location") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { id, from, query, offset, chat_type, location }
}

///|
/// Represents a result of an inline query that was chosen by the user and sent to their chat partner.
pub struct ChosenInlineResult {
  result_id : String
  from : User
  location : Location?
  inline_message_id : String?
  query : String
} derive(Debug, Eq)

///|
/// Creates a new [ChosenInlineResult].
pub fn ChosenInlineResult::new(
  result_id~ : String,
  from~ : User,
  query~ : String,
  location? : Location,
  inline_message_id? : String,
) -> ChosenInlineResult {
  { result_id, from, location, inline_message_id, query }
}

///|
pub impl ToJson for ChosenInlineResult with to_json(self) {
  let object : Map[String, Json] = {
    "result_id": self.result_id.to_json(),
    "from": self.from.to_json(),
    "query": self.query.to_json(),
  }
  if self.location is Some(v) {
    object["location"] = v.to_json()
  }
  if self.inline_message_id is Some(v) {
    object["inline_message_id"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for ChosenInlineResult with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for ChosenInlineResult"),
    )
  }
  let result_id : String = @json.from_json(object["result_id"], path~)
  let from : User = @json.from_json(object["from"], path~)
  let query : String = @json.from_json(object["query"], path~)
  let location : Location? = if object.get("location") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let inline_message_id : String? = if object.get("inline_message_id")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { result_id, from, location, inline_message_id, query }
}

///|
/// Represents a button to be shown above inline query results. You must use exactly one of the optional fields.
pub struct InlineQueryResultsButton {
  text : String
  web_app : WebAppInfo?
  start_parameter : String?
} derive(Debug, Eq)

///|
/// Creates a new [InlineQueryResultsButton].
pub fn InlineQueryResultsButton::new(
  text~ : String,
  web_app? : WebAppInfo,
  start_parameter? : String,
) -> InlineQueryResultsButton {
  { text, web_app, start_parameter }
}

///|
pub impl ToJson for InlineQueryResultsButton with to_json(self) {
  let object : Map[String, Json] = { "text": self.text.to_json() }
  if self.web_app is Some(v) {
    object["web_app"] = v.to_json()
  }
  if self.start_parameter is Some(v) {
    object["start_parameter"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for InlineQueryResultsButton with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InlineQueryResultsButton"),
    )
  }
  let text : String = @json.from_json(object["text"], path~)
  let web_app : WebAppInfo? = if object.get("web_app") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let start_parameter : String? = if object.get("start_parameter") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { text, web_app, start_parameter }
}
