///|
/// Represents a phone contact.
pub struct Contact {
  phone_number : String
  first_name : String
  last_name : String?
  user_id : Int64?
  vcard : String?
} derive(Show, Eq)

///|
/// Creates a new [Contact].
pub fn Contact::new(
  phone_number~ : String,
  first_name~ : String,
  last_name? : String,
  user_id? : Int64,
  vcard? : String,
) -> Contact {
  { phone_number, first_name, last_name, user_id, vcard }
}

///|
pub impl ToJson for Contact with to_json(self) {
  let object : Map[String, Json] = {
    "phone_number": self.phone_number.to_json(),
    "first_name": self.first_name.to_json(),
  }
  if self.last_name is Some(v) {
    object["last_name"] = v.to_json()
  }
  if self.user_id is Some(v) {
    object["user_id"] = int64_to_json(v)
  }
  if self.vcard is Some(v) {
    object["vcard"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for Contact with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for Contact"))
  }
  let phone_number : String = @json.from_json(object["phone_number"], path~)
  let first_name : String = @json.from_json(object["first_name"], path~)
  let last_name : String? = if object.get("last_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let user_id : Int64? = if object.get("user_id") is Some(v) {
    Some(int64_from_json(v, path))
  } else {
    None
  }
  let vcard : String? = if object.get("vcard") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { phone_number, first_name, last_name, user_id, vcard }
}
