///|
test "ReplyKeyboardMarkup simple JSON round-trip" {
  let keyboard = ReplyKeyboardMarkup::new(keyboard=[
    [KeyboardButton::new(text="Button 1"), KeyboardButton::new(text="Button 2")],
    [KeyboardButton::new(text="Button 3")],
  ])
  let json = @json.to_json(keyboard)
  let parsed : ReplyKeyboardMarkup = @json.from_json(json)
  inspect(parsed.keyboard.length(), content="2")
  inspect(parsed.keyboard[0].length(), content="2")
  inspect(parsed.keyboard[0][0].text, content="Button 1")
  inspect(parsed.keyboard[1][0].text, content="Button 3")
  inspect(parsed.is_persistent, content="None")
  inspect(parsed.resize_keyboard, content="None")
}

///|
test "ReplyKeyboardMarkup with options JSON round-trip" {
  let keyboard = ReplyKeyboardMarkup::new(
    keyboard=[[KeyboardButton::new(text="OK")]],
    is_persistent=true,
    resize_keyboard=true,
    one_time_keyboard=true,
    input_field_placeholder="Enter text...",
    selective=false,
  )
  let json = @json.to_json(keyboard)
  let parsed : ReplyKeyboardMarkup = @json.from_json(json)
  inspect(parsed.keyboard.length(), content="1")
  inspect(parsed.is_persistent, content="Some(true)")
  inspect(parsed.resize_keyboard, content="Some(true)")
  inspect(parsed.one_time_keyboard, content="Some(true)")
  inspect(parsed.input_field_placeholder, content="Some(\"Enter text...\")")
  inspect(parsed.selective, content="Some(false)")
}

///|
test "ReplyKeyboardRemove JSON round-trip" {
  let remove = ReplyKeyboardRemove::new(remove_keyboard=true)
  let json = @json.to_json(remove)
  let parsed : ReplyKeyboardRemove = @json.from_json(json)
  inspect(parsed.remove_keyboard, content="true")
  inspect(parsed.selective, content="None")
}

///|
test "ReplyKeyboardRemove with selective JSON round-trip" {
  let remove = ReplyKeyboardRemove::new(remove_keyboard=true, selective=true)
  let json = @json.to_json(remove)
  let parsed : ReplyKeyboardRemove = @json.from_json(json)
  inspect(parsed.remove_keyboard, content="true")
  inspect(parsed.selective, content="Some(true)")
}

///|
test "ForceReply simple JSON round-trip" {
  let force = ForceReply::new(force_reply=true)
  let json = @json.to_json(force)
  let parsed : ForceReply = @json.from_json(json)
  inspect(parsed.force_reply, content="true")
  inspect(parsed.input_field_placeholder, content="None")
  inspect(parsed.selective, content="None")
}

///|
test "ForceReply with options JSON round-trip" {
  let force = ForceReply::new(
    force_reply=true,
    input_field_placeholder="Reply here...",
    selective=true,
  )
  let json = @json.to_json(force)
  let parsed : ForceReply = @json.from_json(json)
  inspect(parsed.force_reply, content="true")
  inspect(parsed.input_field_placeholder, content="Some(\"Reply here...\")")
  inspect(parsed.selective, content="Some(true)")
}

///|
test "ReplyKeyboardMarkup from fixed JSON" {
  let json = @json.parse(
    #|{"keyboard":[[{"text":"Yes"},{"text":"No"}],[{"text":"Cancel"}]],"resize_keyboard":true,"one_time_keyboard":true}
  )
  let markup : ReplyKeyboardMarkup = @json.from_json(json)
  inspect(markup.keyboard.length(), content="2")
  inspect(markup.keyboard[0].length(), content="2")
  inspect(markup.keyboard[0][0].text, content="Yes")
  inspect(markup.keyboard[0][1].text, content="No")
  inspect(markup.keyboard[1][0].text, content="Cancel")
  inspect(markup.resize_keyboard, content="Some(true)")
  inspect(markup.one_time_keyboard, content="Some(true)")
  inspect(markup.is_persistent, content="None")
  inspect(markup.input_field_placeholder, content="None")
  inspect(markup.selective, content="None")
}

///|
test "ReplyKeyboardMarkup from fixed JSON with all options" {
  let json = @json.parse(
    #|{"keyboard":[[{"text":"OK"}]],"is_persistent":true,"resize_keyboard":false,"one_time_keyboard":false,"input_field_placeholder":"Type here","selective":true}
  )
  let markup : ReplyKeyboardMarkup = @json.from_json(json)
  inspect(markup.keyboard[0][0].text, content="OK")
  inspect(markup.is_persistent, content="Some(true)")
  inspect(markup.resize_keyboard, content="Some(false)")
  inspect(markup.one_time_keyboard, content="Some(false)")
  inspect(markup.input_field_placeholder, content="Some(\"Type here\")")
  inspect(markup.selective, content="Some(true)")
}

///|
test "ReplyKeyboardRemove from fixed JSON" {
  let json = @json.parse(
    #|{"remove_keyboard":true}
  )
  let remove : ReplyKeyboardRemove = @json.from_json(json)
  inspect(remove.remove_keyboard, content="true")
  inspect(remove.selective, content="None")
}

///|
test "ReplyKeyboardRemove from fixed JSON with selective" {
  let json = @json.parse(
    #|{"remove_keyboard":true,"selective":true}
  )
  let remove : ReplyKeyboardRemove = @json.from_json(json)
  inspect(remove.remove_keyboard, content="true")
  inspect(remove.selective, content="Some(true)")
}

///|
test "ForceReply from fixed JSON" {
  let json = @json.parse(
    #|{"force_reply":true,"input_field_placeholder":"Your answer"}
  )
  let force : ForceReply = @json.from_json(json)
  inspect(force.force_reply, content="true")
  inspect(force.input_field_placeholder, content="Some(\"Your answer\")")
  inspect(force.selective, content="None")
}

///|
test "ForceReply from fixed JSON minimal" {
  let json = @json.parse(
    #|{"force_reply":true}
  )
  let force : ForceReply = @json.from_json(json)
  inspect(force.force_reply, content="true")
  inspect(force.input_field_placeholder, content="None")
  inspect(force.selective, content="None")
}
