///|
/// Represents a service message about a forum topic closed in the chat.
/// Currently holds no information.
pub struct ForumTopicClosed {} derive(Show, Eq)

///|
/// Creates a new [ForumTopicClosed].
pub fn ForumTopicClosed::new() -> ForumTopicClosed {
  ForumTopicClosed::{  }
}

///|
pub impl ToJson for ForumTopicClosed with to_json(_self) {
  let object : Map[String, Json] = {}
  object.to_json()
}

///|
pub impl @json.FromJson for ForumTopicClosed with from_json(json, path) {
  guard json is Object(_) else {
    raise @json.JsonDecodeError((path, "Expected object for ForumTopicClosed"))
  }
  ForumTopicClosed::{  }
}

///|
/// Represents a service message about a forum topic reopened in the chat.
/// Currently holds no information.
pub struct ForumTopicReopened {} derive(Show, Eq)

///|
/// Creates a new [ForumTopicReopened].
pub fn ForumTopicReopened::new() -> ForumTopicReopened {
  ForumTopicReopened::{  }
}

///|
pub impl ToJson for ForumTopicReopened with to_json(_self) {
  let object : Map[String, Json] = {}
  object.to_json()
}

///|
pub impl @json.FromJson for ForumTopicReopened with from_json(json, path) {
  guard json is Object(_) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for ForumTopicReopened"),
    )
  }
  ForumTopicReopened::{  }
}

///|
/// Represents a service message about General forum topic hidden in the chat.
/// Currently holds no information.
pub struct GeneralForumTopicHidden {} derive(Show, Eq)

///|
/// Creates a new [GeneralForumTopicHidden].
pub fn GeneralForumTopicHidden::new() -> GeneralForumTopicHidden {
  GeneralForumTopicHidden::{  }
}

///|
pub impl ToJson for GeneralForumTopicHidden with to_json(_self) {
  let object : Map[String, Json] = {}
  object.to_json()
}

///|
pub impl @json.FromJson for GeneralForumTopicHidden with from_json(json, path) {
  guard json is Object(_) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for GeneralForumTopicHidden"),
    )
  }
  GeneralForumTopicHidden::{  }
}

///|
/// Represents a service message about General forum topic unhidden in the chat.
/// Currently holds no information.
pub struct GeneralForumTopicUnhidden {} derive(Show, Eq)

///|
/// Creates a new [GeneralForumTopicUnhidden].
pub fn GeneralForumTopicUnhidden::new() -> GeneralForumTopicUnhidden {
  GeneralForumTopicUnhidden::{  }
}

///|
pub impl ToJson for GeneralForumTopicUnhidden with to_json(_self) {
  let object : Map[String, Json] = {}
  object.to_json()
}

///|
pub impl @json.FromJson for GeneralForumTopicUnhidden with from_json(json, path) {
  guard json is Object(_) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for GeneralForumTopicUnhidden"),
    )
  }
  GeneralForumTopicUnhidden::{  }
}

///|
/// Represents a service message about a video chat started in the chat.
/// Currently holds no information.
pub struct VideoChatStarted {} derive(Show, Eq)

///|
/// Creates a new [VideoChatStarted].
pub fn VideoChatStarted::new() -> VideoChatStarted {
  VideoChatStarted::{  }
}

///|
pub impl ToJson for VideoChatStarted with to_json(_self) {
  let object : Map[String, Json] = {}
  object.to_json()
}

///|
pub impl @json.FromJson for VideoChatStarted with from_json(json, path) {
  guard json is Object(_) else {
    raise @json.JsonDecodeError((path, "Expected object for VideoChatStarted"))
  }
  VideoChatStarted::{  }
}

///|
/// Represents a service message about a video chat ended in the chat.
pub struct VideoChatEnded {
  duration : Int
} derive(Show, Eq)

///|
/// Creates a new [VideoChatEnded].
pub fn VideoChatEnded::new(duration~ : Int) -> VideoChatEnded {
  { duration, }
}

///|
pub impl ToJson for VideoChatEnded with to_json(self) {
  let object : Map[String, Json] = { "duration": self.duration.to_json() }
  object.to_json()
}

///|
pub impl @json.FromJson for VideoChatEnded with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for VideoChatEnded"))
  }
  let duration : Int = @json.from_json(object["duration"], path~)
  { duration, }
}

///|
/// Represents a service message about a video chat scheduled in the chat.
pub struct VideoChatScheduled {
  start_date : Int
} derive(Show, Eq)

///|
/// Creates a new [VideoChatScheduled].
pub fn VideoChatScheduled::new(start_date~ : Int) -> VideoChatScheduled {
  { start_date, }
}

///|
pub impl ToJson for VideoChatScheduled with to_json(self) {
  let object : Map[String, Json] = { "start_date": self.start_date.to_json() }
  object.to_json()
}

///|
pub impl @json.FromJson for VideoChatScheduled with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for VideoChatScheduled"),
    )
  }
  let start_date : Int = @json.from_json(object["start_date"], path~)
  { start_date, }
}

///|
/// Represents a service message about new members invited to a video chat.
pub struct VideoChatParticipantsInvited {
  users : Array[User]
} derive(Show, Eq)

///|
/// Creates a new [VideoChatParticipantsInvited].
pub fn VideoChatParticipantsInvited::new(
  users~ : Array[User],
) -> VideoChatParticipantsInvited {
  { users, }
}

///|
pub impl ToJson for VideoChatParticipantsInvited with to_json(self) {
  let object : Map[String, Json] = { "users": self.users.to_json() }
  object.to_json()
}

///|
pub impl @json.FromJson for VideoChatParticipantsInvited with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for VideoChatParticipantsInvited"),
    )
  }
  let users : Array[User] = @json.from_json(object["users"], path~)
  { users, }
}

///|
/// Represents a service message about a change in auto-delete timer settings.
pub struct MessageAutoDeleteTimerChanged {
  message_auto_delete_time : Int
} derive(Show, Eq)

///|
/// Creates a new [MessageAutoDeleteTimerChanged].
pub fn MessageAutoDeleteTimerChanged::new(
  message_auto_delete_time~ : Int,
) -> MessageAutoDeleteTimerChanged {
  { message_auto_delete_time, }
}

///|
pub impl ToJson for MessageAutoDeleteTimerChanged with to_json(self) {
  let object : Map[String, Json] = {
    "message_auto_delete_time": self.message_auto_delete_time.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for MessageAutoDeleteTimerChanged with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for MessageAutoDeleteTimerChanged"),
    )
  }
  let message_auto_delete_time : Int = @json.from_json(
    object["message_auto_delete_time"],
    path~,
  )
  { message_auto_delete_time, }
}

///|
/// Represents a service message about a user boosting a chat.
pub struct ChatBoostAdded {
  boost_count : Int
} derive(Show, Eq)

///|
/// Creates a new [ChatBoostAdded].
pub fn ChatBoostAdded::new(boost_count~ : Int) -> ChatBoostAdded {
  { boost_count, }
}

///|
pub impl ToJson for ChatBoostAdded with to_json(self) {
  let object : Map[String, Json] = { "boost_count": self.boost_count.to_json() }
  object.to_json()
}

///|
pub impl @json.FromJson for ChatBoostAdded with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for ChatBoostAdded"))
  }
  let boost_count : Int = @json.from_json(object["boost_count"], path~)
  { boost_count, }
}

///|
/// Represents the content of a service message, sent whenever a user in the
/// chat triggers a proximity alert set by another user.
pub struct ProximityAlertTriggered {
  traveler : User
  watcher : User
  distance : Int
} derive(Show, Eq)

///|
/// Creates a new [ProximityAlertTriggered].
pub fn ProximityAlertTriggered::new(
  traveler~ : User,
  watcher~ : User,
  distance~ : Int,
) -> ProximityAlertTriggered {
  { traveler, watcher, distance }
}

///|
pub impl ToJson for ProximityAlertTriggered with to_json(self) {
  let object : Map[String, Json] = {
    "traveler": self.traveler.to_json(),
    "watcher": self.watcher.to_json(),
    "distance": self.distance.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for ProximityAlertTriggered with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for ProximityAlertTriggered"),
    )
  }
  let traveler : User = @json.from_json(object["traveler"], path~)
  let watcher : User = @json.from_json(object["watcher"], path~)
  let distance : Int = @json.from_json(object["distance"], path~)
  { traveler, watcher, distance }
}

///|
/// Represents a service message about a user allowing a bot to write messages
/// after adding it to the attachment menu, launching a Web App from a link, or
/// accepting an explicit request from a Web App.
pub struct WriteAccessAllowed {
  from_request : Bool?
  web_app_name : String?
  from_attachment_menu : Bool?
} derive(Show, Eq)

///|
/// Creates a new [WriteAccessAllowed].
pub fn WriteAccessAllowed::new(
  from_request? : Bool,
  web_app_name? : String,
  from_attachment_menu? : Bool,
) -> WriteAccessAllowed {
  { from_request, web_app_name, from_attachment_menu }
}

///|
pub impl ToJson for WriteAccessAllowed with to_json(self) {
  let object : Map[String, Json] = {}
  if self.from_request is Some(v) {
    object["from_request"] = v.to_json()
  }
  if self.web_app_name is Some(v) {
    object["web_app_name"] = v.to_json()
  }
  if self.from_attachment_menu is Some(v) {
    object["from_attachment_menu"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for WriteAccessAllowed with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for WriteAccessAllowed"),
    )
  }
  let from_request : Bool? = if object.get("from_request") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let web_app_name : String? = if object.get("web_app_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let from_attachment_menu : Bool? = if object.get("from_attachment_menu")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { from_request, web_app_name, from_attachment_menu }
}

///|
/// Describes data sent from a Web App to the bot.
pub struct WebAppData {
  data : String
  button_text : String
} derive(Show, Eq)

///|
/// Creates a new [WebAppData].
pub fn WebAppData::new(data~ : String, button_text~ : String) -> WebAppData {
  { data, button_text }
}

///|
pub impl ToJson for WebAppData with to_json(self) {
  let object : Map[String, Json] = {
    "data": self.data.to_json(),
    "button_text": self.button_text.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for WebAppData with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for WebAppData"))
  }
  let data : String = @json.from_json(object["data"], path~)
  let button_text : String = @json.from_json(object["button_text"], path~)
  { data, button_text }
}
