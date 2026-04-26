///|
/// Represents an animated emoji that displays a random value.
pub struct Dice {
  emoji : String
  value : Int
} derive(Debug, Eq)

///|
/// Creates a new [Dice].
pub fn Dice::new(emoji~ : String, value~ : Int) -> Dice {
  { emoji, value }
}

///|
pub impl ToJson for Dice with to_json(self) {
  let object : Map[String, Json] = {
    "emoji": self.emoji.to_json(),
    "value": self.value.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for Dice with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for Dice"))
  }
  let emoji : String = @json.from_json(object["emoji"], path~)
  let value : Int = @json.from_json(object["value"], path~)
  { emoji, value }
}
