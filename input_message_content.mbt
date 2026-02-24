///|
/// Represents the content of a text message to be sent as the result of an inline query.
pub struct InputTextMessageContent {
  message_text : String
  parse_mode : String?
  entities : Array[MessageEntity]?
  link_preview_options : LinkPreviewOptions?
} derive(Show, Eq)

///|
/// Creates a new [InputTextMessageContent].
pub fn InputTextMessageContent::new(
  message_text~ : String,
  parse_mode? : String,
  entities? : Array[MessageEntity],
  link_preview_options? : LinkPreviewOptions,
) -> InputTextMessageContent {
  { message_text, parse_mode, entities, link_preview_options }
}

///|
pub impl ToJson for InputTextMessageContent with to_json(self) {
  let object : Map[String, Json] = {
    "message_text": self.message_text.to_json(),
  }
  if self.parse_mode is Some(v) {
    object["parse_mode"] = v.to_json()
  }
  if self.entities is Some(v) {
    object["entities"] = v.to_json()
  }
  if self.link_preview_options is Some(v) {
    object["link_preview_options"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for InputTextMessageContent with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InputTextMessageContent"),
    )
  }
  let message_text : String = @json.from_json(object["message_text"], path~)
  let parse_mode : String? = if object.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let entities : Array[MessageEntity]? = if object.get("entities") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let link_preview_options : LinkPreviewOptions? = if object.get(
      "link_preview_options",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { message_text, parse_mode, entities, link_preview_options }
}

///|
/// Represents the content of a location message to be sent as the result of an inline query.
pub struct InputLocationMessageContent {
  latitude : Double
  longitude : Double
  horizontal_accuracy : Double?
  live_period : Int?
  heading : Int?
  proximity_alert_radius : Int?
} derive(Show, Eq)

///|
/// Creates a new [InputLocationMessageContent].
pub fn InputLocationMessageContent::new(
  latitude~ : Double,
  longitude~ : Double,
  horizontal_accuracy? : Double,
  live_period? : Int,
  heading? : Int,
  proximity_alert_radius? : Int,
) -> InputLocationMessageContent {
  {
    latitude,
    longitude,
    horizontal_accuracy,
    live_period,
    heading,
    proximity_alert_radius,
  }
}

///|
pub impl ToJson for InputLocationMessageContent with to_json(self) {
  let object : Map[String, Json] = {
    "latitude": self.latitude.to_json(),
    "longitude": self.longitude.to_json(),
  }
  if self.horizontal_accuracy is Some(v) {
    object["horizontal_accuracy"] = v.to_json()
  }
  if self.live_period is Some(v) {
    object["live_period"] = v.to_json()
  }
  if self.heading is Some(v) {
    object["heading"] = v.to_json()
  }
  if self.proximity_alert_radius is Some(v) {
    object["proximity_alert_radius"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for InputLocationMessageContent with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InputLocationMessageContent"),
    )
  }
  let latitude : Double = @json.from_json(object["latitude"], path~)
  let longitude : Double = @json.from_json(object["longitude"], path~)
  let horizontal_accuracy : Double? = if object.get("horizontal_accuracy")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let live_period : Int? = if object.get("live_period") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let heading : Int? = if object.get("heading") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let proximity_alert_radius : Int? = if object.get("proximity_alert_radius")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    latitude,
    longitude,
    horizontal_accuracy,
    live_period,
    heading,
    proximity_alert_radius,
  }
}

///|
/// Represents the content of a venue message to be sent as the result of an inline query.
pub struct InputVenueMessageContent {
  latitude : Double
  longitude : Double
  title : String
  address : String
  foursquare_id : String?
  foursquare_type : String?
  google_place_id : String?
  google_place_type : String?
} derive(Show, Eq)

///|
/// Creates a new [InputVenueMessageContent].
pub fn InputVenueMessageContent::new(
  latitude~ : Double,
  longitude~ : Double,
  title~ : String,
  address~ : String,
  foursquare_id? : String,
  foursquare_type? : String,
  google_place_id? : String,
  google_place_type? : String,
) -> InputVenueMessageContent {
  {
    latitude,
    longitude,
    title,
    address,
    foursquare_id,
    foursquare_type,
    google_place_id,
    google_place_type,
  }
}

///|
pub impl ToJson for InputVenueMessageContent with to_json(self) {
  let object : Map[String, Json] = {
    "latitude": self.latitude.to_json(),
    "longitude": self.longitude.to_json(),
    "title": self.title.to_json(),
    "address": self.address.to_json(),
  }
  if self.foursquare_id is Some(v) {
    object["foursquare_id"] = v.to_json()
  }
  if self.foursquare_type is Some(v) {
    object["foursquare_type"] = v.to_json()
  }
  if self.google_place_id is Some(v) {
    object["google_place_id"] = v.to_json()
  }
  if self.google_place_type is Some(v) {
    object["google_place_type"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for InputVenueMessageContent with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InputVenueMessageContent"),
    )
  }
  let latitude : Double = @json.from_json(object["latitude"], path~)
  let longitude : Double = @json.from_json(object["longitude"], path~)
  let title : String = @json.from_json(object["title"], path~)
  let address : String = @json.from_json(object["address"], path~)
  let foursquare_id : String? = if object.get("foursquare_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let foursquare_type : String? = if object.get("foursquare_type") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let google_place_id : String? = if object.get("google_place_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let google_place_type : String? = if object.get("google_place_type")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    latitude,
    longitude,
    title,
    address,
    foursquare_id,
    foursquare_type,
    google_place_id,
    google_place_type,
  }
}

///|
/// Represents the content of a contact message to be sent as the result of an inline query.
pub struct InputContactMessageContent {
  phone_number : String
  first_name : String
  last_name : String?
  vcard : String?
} derive(Show, Eq)

///|
/// Creates a new [InputContactMessageContent].
pub fn InputContactMessageContent::new(
  phone_number~ : String,
  first_name~ : String,
  last_name? : String,
  vcard? : String,
) -> InputContactMessageContent {
  { phone_number, first_name, last_name, vcard }
}

///|
pub impl ToJson for InputContactMessageContent with to_json(self) {
  let object : Map[String, Json] = {
    "phone_number": self.phone_number.to_json(),
    "first_name": self.first_name.to_json(),
  }
  if self.last_name is Some(v) {
    object["last_name"] = v.to_json()
  }
  if self.vcard is Some(v) {
    object["vcard"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for InputContactMessageContent with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InputContactMessageContent"),
    )
  }
  let phone_number : String = @json.from_json(object["phone_number"], path~)
  let first_name : String = @json.from_json(object["first_name"], path~)
  let last_name : String? = if object.get("last_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let vcard : String? = if object.get("vcard") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { phone_number, first_name, last_name, vcard }
}

///|
/// Represents the content of an invoice message to be sent as the result of an inline query.
pub struct InputInvoiceMessageContent {
  title : String
  description : String
  payload : String
  provider_token : String?
  currency : String
  prices : Array[LabeledPrice]
  max_tip_amount : Int?
  suggested_tip_amounts : Array[Int]?
  provider_data : String?
  photo_url : String?
  photo_size : Int?
  photo_width : Int?
  photo_height : Int?
  need_name : Bool?
  need_phone_number : Bool?
  need_email : Bool?
  need_shipping_address : Bool?
  send_phone_number_to_provider : Bool?
  send_email_to_provider : Bool?
  is_flexible : Bool?
} derive(Show, Eq)

///|
/// Creates a new [InputInvoiceMessageContent].
pub fn InputInvoiceMessageContent::new(
  title~ : String,
  description~ : String,
  payload~ : String,
  provider_token? : String,
  currency~ : String,
  prices~ : Array[LabeledPrice],
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
) -> InputInvoiceMessageContent {
  {
    title,
    description,
    payload,
    provider_token,
    currency,
    prices,
    max_tip_amount,
    suggested_tip_amounts,
    provider_data,
    photo_url,
    photo_size,
    photo_width,
    photo_height,
    need_name,
    need_phone_number,
    need_email,
    need_shipping_address,
    send_phone_number_to_provider,
    send_email_to_provider,
    is_flexible,
  }
}

///|
pub impl ToJson for InputInvoiceMessageContent with to_json(self) {
  let object : Map[String, Json] = {
    "title": self.title.to_json(),
    "description": self.description.to_json(),
    "payload": self.payload.to_json(),
    "currency": self.currency.to_json(),
    "prices": self.prices.to_json(),
  }
  if self.provider_token is Some(v) {
    object["provider_token"] = v.to_json()
  }
  if self.max_tip_amount is Some(v) {
    object["max_tip_amount"] = v.to_json()
  }
  if self.suggested_tip_amounts is Some(v) {
    object["suggested_tip_amounts"] = v.to_json()
  }
  if self.provider_data is Some(v) {
    object["provider_data"] = v.to_json()
  }
  if self.photo_url is Some(v) {
    object["photo_url"] = v.to_json()
  }
  if self.photo_size is Some(v) {
    object["photo_size"] = v.to_json()
  }
  if self.photo_width is Some(v) {
    object["photo_width"] = v.to_json()
  }
  if self.photo_height is Some(v) {
    object["photo_height"] = v.to_json()
  }
  if self.need_name is Some(v) {
    object["need_name"] = v.to_json()
  }
  if self.need_phone_number is Some(v) {
    object["need_phone_number"] = v.to_json()
  }
  if self.need_email is Some(v) {
    object["need_email"] = v.to_json()
  }
  if self.need_shipping_address is Some(v) {
    object["need_shipping_address"] = v.to_json()
  }
  if self.send_phone_number_to_provider is Some(v) {
    object["send_phone_number_to_provider"] = v.to_json()
  }
  if self.send_email_to_provider is Some(v) {
    object["send_email_to_provider"] = v.to_json()
  }
  if self.is_flexible is Some(v) {
    object["is_flexible"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for InputInvoiceMessageContent with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InputInvoiceMessageContent"),
    )
  }
  let title : String = @json.from_json(object["title"], path~)
  let description : String = @json.from_json(object["description"], path~)
  let payload : String = @json.from_json(object["payload"], path~)
  let provider_token : String? = if object.get("provider_token") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let currency : String = @json.from_json(object["currency"], path~)
  let prices : Array[LabeledPrice] = @json.from_json(object["prices"], path~)
  let max_tip_amount : Int? = if object.get("max_tip_amount") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let suggested_tip_amounts : Array[Int]? = if object.get(
      "suggested_tip_amounts",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let provider_data : String? = if object.get("provider_data") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let photo_url : String? = if object.get("photo_url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let photo_size : Int? = if object.get("photo_size") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let photo_width : Int? = if object.get("photo_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let photo_height : Int? = if object.get("photo_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let need_name : Bool? = if object.get("need_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let need_phone_number : Bool? = if object.get("need_phone_number") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let need_email : Bool? = if object.get("need_email") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let need_shipping_address : Bool? = if object.get("need_shipping_address")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let send_phone_number_to_provider : Bool? = if object.get(
      "send_phone_number_to_provider",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let send_email_to_provider : Bool? = if object.get("send_email_to_provider")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let is_flexible : Bool? = if object.get("is_flexible") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    title,
    description,
    payload,
    provider_token,
    currency,
    prices,
    max_tip_amount,
    suggested_tip_amounts,
    provider_data,
    photo_url,
    photo_size,
    photo_width,
    photo_height,
    need_name,
    need_phone_number,
    need_email,
    need_shipping_address,
    send_phone_number_to_provider,
    send_email_to_provider,
    is_flexible,
  }
}

///|
/// Represents the content of a message to be sent as a result of an inline query.
pub(all) enum InputMessageContent {
  Text(InputTextMessageContent)
  Location(InputLocationMessageContent)
  Venue(InputVenueMessageContent)
  Contact(InputContactMessageContent)
  Invoice(InputInvoiceMessageContent)
} derive(Show, Eq)

///|
pub impl ToJson for InputMessageContent with to_json(self) {
  match self {
    Text(v) => v.to_json()
    Location(v) => v.to_json()
    Venue(v) => v.to_json()
    Contact(v) => v.to_json()
    Invoice(v) => v.to_json()
  }
}

///|
pub impl @json.FromJson for InputMessageContent with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InputMessageContent"),
    )
  }
  // Determine type based on fields present
  // Text: has message_text
  // Location: has latitude, longitude (but not title/address)
  // Venue: has latitude, longitude, title, address
  // Contact: has phone_number, first_name
  // Invoice: has title, description, payload, currency, prices
  if object.contains("message_text") {
    Text(@json.from_json(json, path~))
  } else if object.contains("phone_number") && object.contains("first_name") {
    Contact(@json.from_json(json, path~))
  } else if object.contains("payload") &&
    object.contains("currency") &&
    object.contains("prices") {
    Invoice(@json.from_json(json, path~))
  } else if object.contains("latitude") &&
    object.contains("longitude") &&
    object.contains("title") &&
    object.contains("address") {
    Venue(@json.from_json(json, path~))
  } else if object.contains("latitude") && object.contains("longitude") {
    Location(@json.from_json(json, path~))
  } else {
    raise @json.JsonDecodeError(
      (path, "Cannot determine InputMessageContent type from fields"),
    )
  }
}
