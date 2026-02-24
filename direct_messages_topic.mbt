///|
/// This object represents a direct messages topic.
pub struct DirectMessagesTopic {
  id : Int
  name : String
  icon_color : Int
} derive(Show, Eq)

///|
/// Creates a new [DirectMessagesTopic].
pub fn DirectMessagesTopic::new(
  id~ : Int,
  name~ : String,
  icon_color~ : Int,
) -> DirectMessagesTopic {
  { id, name, icon_color }
}

///|
pub impl ToJson for DirectMessagesTopic with to_json(self) {
  let object : Map[String, Json] = {
    "id": self.id.to_json(),
    "name": self.name.to_json(),
    "icon_color": self.icon_color.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for DirectMessagesTopic with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for DirectMessagesTopic"),
    )
  }
  let id : Int = @json.from_json(object["id"], path~)
  let name : String = @json.from_json(object["name"], path~)
  let icon_color : Int = @json.from_json(object["icon_color"], path~)
  { id, name, icon_color }
}
