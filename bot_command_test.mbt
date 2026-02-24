///|
test "BotCommand JSON round-trip" {
  let cmd = BotCommand::new(command="start", description="Start the bot")
  let json = @json.to_json(cmd)
  let parsed : BotCommand = @json.from_json(json)
  inspect(parsed.command, content="start")
  inspect(parsed.description, content="Start the bot")
}

///|
test "BotCommand from fixed JSON" {
  let json = @json.parse(
    #|{"command":"start","description":"Start the bot"}
  )
  let cmd : BotCommand = @json.from_json(json)
  inspect(cmd.command, content="start")
  inspect(cmd.description, content="Start the bot")
}

///|
test "BotCommand from fixed JSON help command" {
  let json = @json.parse(
    #|{"command":"help","description":"Show help information"}
  )
  let cmd : BotCommand = @json.from_json(json)
  inspect(cmd.command, content="help")
  inspect(cmd.description, content="Show help information")
}
