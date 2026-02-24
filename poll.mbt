///|
/// Contains information about one answer option in a poll.
pub struct PollOption {
  text : String
  text_entities : Array[MessageEntity]?
  voter_count : Int
} derive(Show, Eq)

///|
/// Creates a new [PollOption].
pub fn PollOption::new(
  text~ : String,
  text_entities? : Array[MessageEntity],
  voter_count~ : Int,
) -> PollOption {
  { text, text_entities, voter_count }
}

///|
pub impl ToJson for PollOption with to_json(self) {
  let object : Map[String, Json] = {
    "text": self.text.to_json(),
    "voter_count": self.voter_count.to_json(),
  }
  if self.text_entities is Some(v) {
    object["text_entities"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for PollOption with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for PollOption"))
  }
  let text : String = @json.from_json(object["text"], path~)
  let text_entities : Array[MessageEntity]? = if object.get("text_entities")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let voter_count : Int = @json.from_json(object["voter_count"], path~)
  { text, text_entities, voter_count }
}

///|
/// Contains information about one answer option in a poll to be sent.
pub struct InputPollOption {
  text : String
  text_parse_mode : String?
  text_entities : Array[MessageEntity]?
} derive(Show, Eq)

///|
/// Creates a new [InputPollOption].
pub fn InputPollOption::new(
  text~ : String,
  text_parse_mode? : String,
  text_entities? : Array[MessageEntity],
) -> InputPollOption {
  { text, text_parse_mode, text_entities }
}

///|
pub impl ToJson for InputPollOption with to_json(self) {
  let object : Map[String, Json] = { "text": self.text.to_json() }
  if self.text_parse_mode is Some(v) {
    object["text_parse_mode"] = v.to_json()
  }
  if self.text_entities is Some(v) {
    object["text_entities"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for InputPollOption with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for InputPollOption"))
  }
  let text : String = @json.from_json(object["text"], path~)
  let text_parse_mode : String? = if object.get("text_parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let text_entities : Array[MessageEntity]? = if object.get("text_entities")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { text, text_parse_mode, text_entities }
}

///|
/// Contains information about a poll.
pub struct Poll {
  id : String
  question : String
  question_entities : Array[MessageEntity]?
  options : Array[PollOption]
  total_voter_count : Int
  is_closed : Bool
  is_anonymous : Bool
  type_ : String
  allows_multiple_answers : Bool
  correct_option_id : Int?
  explanation : String?
  explanation_entities : Array[MessageEntity]?
  open_period : Int?
  close_date : Int?
} derive(Show, Eq)

///|
/// Creates a new [Poll].
pub fn Poll::new(
  id~ : String,
  question~ : String,
  question_entities? : Array[MessageEntity],
  options~ : Array[PollOption],
  total_voter_count~ : Int,
  is_closed~ : Bool,
  is_anonymous~ : Bool,
  type_~ : String,
  allows_multiple_answers~ : Bool,
  correct_option_id? : Int,
  explanation? : String,
  explanation_entities? : Array[MessageEntity],
  open_period? : Int,
  close_date? : Int,
) -> Poll {
  {
    id,
    question,
    question_entities,
    options,
    total_voter_count,
    is_closed,
    is_anonymous,
    type_,
    allows_multiple_answers,
    correct_option_id,
    explanation,
    explanation_entities,
    open_period,
    close_date,
  }
}

///|
pub impl ToJson for Poll with to_json(self) {
  let object : Map[String, Json] = {
    "id": self.id.to_json(),
    "question": self.question.to_json(),
    "options": self.options.to_json(),
    "total_voter_count": self.total_voter_count.to_json(),
    "is_closed": self.is_closed.to_json(),
    "is_anonymous": self.is_anonymous.to_json(),
    "type": self.type_.to_json(),
    "allows_multiple_answers": self.allows_multiple_answers.to_json(),
  }
  if self.question_entities is Some(v) {
    object["question_entities"] = v.to_json()
  }
  if self.correct_option_id is Some(v) {
    object["correct_option_id"] = v.to_json()
  }
  if self.explanation is Some(v) {
    object["explanation"] = v.to_json()
  }
  if self.explanation_entities is Some(v) {
    object["explanation_entities"] = v.to_json()
  }
  if self.open_period is Some(v) {
    object["open_period"] = v.to_json()
  }
  if self.close_date is Some(v) {
    object["close_date"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for Poll with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for Poll"))
  }
  let id : String = @json.from_json(object["id"], path~)
  let question : String = @json.from_json(object["question"], path~)
  let question_entities : Array[MessageEntity]? = if object.get(
      "question_entities",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let options : Array[PollOption] = @json.from_json(object["options"], path~)
  let total_voter_count : Int = @json.from_json(
    object["total_voter_count"],
    path~,
  )
  let is_closed : Bool = @json.from_json(object["is_closed"], path~)
  let is_anonymous : Bool = @json.from_json(object["is_anonymous"], path~)
  let type_ : String = @json.from_json(object["type"], path~)
  let allows_multiple_answers : Bool = @json.from_json(
    object["allows_multiple_answers"],
    path~,
  )
  let correct_option_id : Int? = if object.get("correct_option_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let explanation : String? = if object.get("explanation") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let explanation_entities : Array[MessageEntity]? = if object.get(
      "explanation_entities",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let open_period : Int? = if object.get("open_period") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let close_date : Int? = if object.get("close_date") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    id,
    question,
    question_entities,
    options,
    total_voter_count,
    is_closed,
    is_anonymous,
    type_,
    allows_multiple_answers,
    correct_option_id,
    explanation,
    explanation_entities,
    open_period,
    close_date,
  }
}

///|
/// Represents an answer of a user in a non-anonymous poll.
pub struct PollAnswer {
  poll_id : String
  voter_chat : Chat?
  user : User?
  option_ids : Array[Int]
} derive(Show, Eq)

///|
/// Creates a new [PollAnswer].
pub fn PollAnswer::new(
  poll_id~ : String,
  voter_chat? : Chat,
  user? : User,
  option_ids~ : Array[Int],
) -> PollAnswer {
  { poll_id, voter_chat, user, option_ids }
}

///|
pub impl ToJson for PollAnswer with to_json(self) {
  let object : Map[String, Json] = {
    "poll_id": self.poll_id.to_json(),
    "option_ids": self.option_ids.to_json(),
  }
  if self.voter_chat is Some(v) {
    object["voter_chat"] = v.to_json()
  }
  if self.user is Some(v) {
    object["user"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for PollAnswer with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for PollAnswer"))
  }
  let poll_id : String = @json.from_json(object["poll_id"], path~)
  let voter_chat : Chat? = if object.get("voter_chat") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let user : User? = if object.get("user") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let option_ids : Array[Int] = @json.from_json(object["option_ids"], path~)
  { poll_id, voter_chat, user, option_ids }
}
