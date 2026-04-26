///|
/// Represents a service message about the creation of a scheduled giveaway.
pub struct GiveawayCreated {
  prize_star_count : Int?
} derive(Debug, Eq)

///|
/// Creates a new [GiveawayCreated].
pub fn GiveawayCreated::new(prize_star_count? : Int) -> GiveawayCreated {
  { prize_star_count, }
}

///|
pub impl ToJson for GiveawayCreated with to_json(self) {
  let object : Map[String, Json] = {}
  if self.prize_star_count is Some(v) {
    object["prize_star_count"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for GiveawayCreated with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for GiveawayCreated"))
  }
  let prize_star_count : Int? = if object.get("prize_star_count") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { prize_star_count, }
}

///|
/// Represents a message about a scheduled giveaway.
pub struct Giveaway {
  chats : Array[Chat]
  winners_selection_date : Int
  winner_count : Int
  only_new_members : Bool?
  has_public_winners : Bool?
  prize_description : String?
  country_codes : Array[String]?
  prize_star_count : Int?
  premium_subscription_month_count : Int?
} derive(Debug, Eq)

///|
/// Creates a new [Giveaway].
pub fn Giveaway::new(
  chats~ : Array[Chat],
  winners_selection_date~ : Int,
  winner_count~ : Int,
  only_new_members? : Bool,
  has_public_winners? : Bool,
  prize_description? : String,
  country_codes? : Array[String],
  prize_star_count? : Int,
  premium_subscription_month_count? : Int,
) -> Giveaway {
  {
    chats,
    winners_selection_date,
    winner_count,
    only_new_members,
    has_public_winners,
    prize_description,
    country_codes,
    prize_star_count,
    premium_subscription_month_count,
  }
}

///|
pub impl ToJson for Giveaway with to_json(self) {
  let object : Map[String, Json] = {
    "chats": self.chats.to_json(),
    "winners_selection_date": self.winners_selection_date.to_json(),
    "winner_count": self.winner_count.to_json(),
  }
  if self.only_new_members is Some(v) {
    object["only_new_members"] = v.to_json()
  }
  if self.has_public_winners is Some(v) {
    object["has_public_winners"] = v.to_json()
  }
  if self.prize_description is Some(v) {
    object["prize_description"] = v.to_json()
  }
  if self.country_codes is Some(v) {
    object["country_codes"] = v.to_json()
  }
  if self.prize_star_count is Some(v) {
    object["prize_star_count"] = v.to_json()
  }
  if self.premium_subscription_month_count is Some(v) {
    object["premium_subscription_month_count"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for Giveaway with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for Giveaway"))
  }
  let chats : Array[Chat] = @json.from_json(object["chats"], path~)
  let winners_selection_date : Int = @json.from_json(
    object["winners_selection_date"],
    path~,
  )
  let winner_count : Int = @json.from_json(object["winner_count"], path~)
  let only_new_members : Bool? = if object.get("only_new_members") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let has_public_winners : Bool? = if object.get("has_public_winners")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let prize_description : String? = if object.get("prize_description")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let country_codes : Array[String]? = if object.get("country_codes") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let prize_star_count : Int? = if object.get("prize_star_count") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let premium_subscription_month_count : Int? = if object.get(
      "premium_subscription_month_count",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    chats,
    winners_selection_date,
    winner_count,
    only_new_members,
    has_public_winners,
    prize_description,
    country_codes,
    prize_star_count,
    premium_subscription_month_count,
  }
}

///|
/// Represents a message about the completion of a giveaway with public winners.
pub struct GiveawayWinners {
  chat : Chat
  giveaway_message_id : Int
  winners_selection_date : Int
  winner_count : Int
  winners : Array[User]
  additional_chat_count : Int?
  prize_star_count : Int?
  premium_subscription_month_count : Int?
  unclaimed_prize_count : Int?
  only_new_members : Bool?
  was_refunded : Bool?
  prize_description : String?
} derive(Debug, Eq)

///|
/// Creates a new [GiveawayWinners].
pub fn GiveawayWinners::new(
  chat~ : Chat,
  giveaway_message_id~ : Int,
  winners_selection_date~ : Int,
  winner_count~ : Int,
  winners~ : Array[User],
  additional_chat_count? : Int,
  prize_star_count? : Int,
  premium_subscription_month_count? : Int,
  unclaimed_prize_count? : Int,
  only_new_members? : Bool,
  was_refunded? : Bool,
  prize_description? : String,
) -> GiveawayWinners {
  {
    chat,
    giveaway_message_id,
    winners_selection_date,
    winner_count,
    winners,
    additional_chat_count,
    prize_star_count,
    premium_subscription_month_count,
    unclaimed_prize_count,
    only_new_members,
    was_refunded,
    prize_description,
  }
}

///|
pub impl ToJson for GiveawayWinners with to_json(self) {
  let object : Map[String, Json] = {
    "chat": self.chat.to_json(),
    "giveaway_message_id": self.giveaway_message_id.to_json(),
    "winners_selection_date": self.winners_selection_date.to_json(),
    "winner_count": self.winner_count.to_json(),
    "winners": self.winners.to_json(),
  }
  if self.additional_chat_count is Some(v) {
    object["additional_chat_count"] = v.to_json()
  }
  if self.prize_star_count is Some(v) {
    object["prize_star_count"] = v.to_json()
  }
  if self.premium_subscription_month_count is Some(v) {
    object["premium_subscription_month_count"] = v.to_json()
  }
  if self.unclaimed_prize_count is Some(v) {
    object["unclaimed_prize_count"] = v.to_json()
  }
  if self.only_new_members is Some(v) {
    object["only_new_members"] = v.to_json()
  }
  if self.was_refunded is Some(v) {
    object["was_refunded"] = v.to_json()
  }
  if self.prize_description is Some(v) {
    object["prize_description"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for GiveawayWinners with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for GiveawayWinners"))
  }
  let chat : Chat = @json.from_json(object["chat"], path~)
  let giveaway_message_id : Int = @json.from_json(
    object["giveaway_message_id"],
    path~,
  )
  let winners_selection_date : Int = @json.from_json(
    object["winners_selection_date"],
    path~,
  )
  let winner_count : Int = @json.from_json(object["winner_count"], path~)
  let winners : Array[User] = @json.from_json(object["winners"], path~)
  let additional_chat_count : Int? = if object.get("additional_chat_count")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let prize_star_count : Int? = if object.get("prize_star_count") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let premium_subscription_month_count : Int? = if object.get(
      "premium_subscription_month_count",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let unclaimed_prize_count : Int? = if object.get("unclaimed_prize_count")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let only_new_members : Bool? = if object.get("only_new_members") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let was_refunded : Bool? = if object.get("was_refunded") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let prize_description : String? = if object.get("prize_description")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    chat,
    giveaway_message_id,
    winners_selection_date,
    winner_count,
    winners,
    additional_chat_count,
    prize_star_count,
    premium_subscription_month_count,
    unclaimed_prize_count,
    only_new_members,
    was_refunded,
    prize_description,
  }
}

///|
/// Represents a service message about the completion of a giveaway without
/// public winners.
pub struct GiveawayCompleted {
  winner_count : Int
  unclaimed_prize_count : Int?
  giveaway_message : Message?
  is_star_giveaway : Bool?
} derive(Debug, Eq)

///|
/// Creates a new [GiveawayCompleted].
pub fn GiveawayCompleted::new(
  winner_count~ : Int,
  unclaimed_prize_count? : Int,
  giveaway_message? : Message,
  is_star_giveaway? : Bool,
) -> GiveawayCompleted {
  { winner_count, unclaimed_prize_count, giveaway_message, is_star_giveaway }
}

///|
pub impl ToJson for GiveawayCompleted with to_json(self) {
  let object : Map[String, Json] = {
    "winner_count": self.winner_count.to_json(),
  }
  if self.unclaimed_prize_count is Some(v) {
    object["unclaimed_prize_count"] = v.to_json()
  }
  if self.giveaway_message is Some(v) {
    object["giveaway_message"] = v.to_json()
  }
  if self.is_star_giveaway is Some(v) {
    object["is_star_giveaway"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for GiveawayCompleted with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for GiveawayCompleted"))
  }
  let winner_count : Int = @json.from_json(object["winner_count"], path~)
  let unclaimed_prize_count : Int? = if object.get("unclaimed_prize_count")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let giveaway_message : Message? = if object.get("giveaway_message") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let is_star_giveaway : Bool? = if object.get("is_star_giveaway") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { winner_count, unclaimed_prize_count, giveaway_message, is_star_giveaway }
}
