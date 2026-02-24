///|
/// This object represents a bot command.
pub struct BotCommand {
  command : String
  description : String
} derive(Show, Eq)

///|
/// Creates a new [BotCommand].
pub fn BotCommand::new(command~ : String, description~ : String) -> BotCommand {
  { command, description }
}

///|
pub impl ToJson for BotCommand with to_json(self) {
  let object : Map[String, Json] = {
    "command": self.command.to_json(),
    "description": self.description.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for BotCommand with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for BotCommand"))
  }
  let command : String = @json.from_json(object["command"], path~)
  let description : String = @json.from_json(object["description"], path~)
  { command, description }
}
