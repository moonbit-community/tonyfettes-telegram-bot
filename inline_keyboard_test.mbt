///|
test "InlineKeyboardButton with callback_data JSON round-trip" {
  let button = InlineKeyboardButton::new(text="Click me", callback_data="btn_1")
  let json = @json.to_json(button)
  let parsed : InlineKeyboardButton = @json.from_json(json)
  inspect(parsed.text, content="Click me")
  inspect(parsed.callback_data, content="Some(\"btn_1\")")
  inspect(parsed.url, content="None")
}

///|
test "InlineKeyboardButton with url JSON round-trip" {
  let button = InlineKeyboardButton::new(
    text="Visit site",
    url="https://example.com",
  )
  let json = @json.to_json(button)
  let parsed : InlineKeyboardButton = @json.from_json(json)
  inspect(parsed.text, content="Visit site")
  inspect(parsed.url, content="Some(\"https://example.com\")")
  inspect(parsed.callback_data, content="None")
}

///|
test "InlineKeyboardMarkup JSON round-trip" {
  let keyboard = InlineKeyboardMarkup::new(inline_keyboard=[
    [
      InlineKeyboardButton::new(text="Button 1", callback_data="1"),
      InlineKeyboardButton::new(text="Button 2", callback_data="2"),
    ],
    [InlineKeyboardButton::new(text="URL", url="https://example.com")],
  ])
  let json = @json.to_json(keyboard)
  let parsed : InlineKeyboardMarkup = @json.from_json(json)
  inspect(parsed.inline_keyboard.length(), content="2")
  inspect(parsed.inline_keyboard[0].length(), content="2")
  inspect(parsed.inline_keyboard[0][0].text, content="Button 1")
  inspect(
    parsed.inline_keyboard[1][0].url,
    content="Some(\"https://example.com\")",
  )
}

///|
test "InlineKeyboardButton from fixed JSON" {
  let json = @json.parse(
    (
      #|{"text":"Click me","url":"https://example.com"}
    ),
  )
  let btn : InlineKeyboardButton = @json.from_json(json)
  inspect(btn.text, content="Click me")
  inspect(btn.url, content="Some(\"https://example.com\")")
  inspect(btn.callback_data, content="None")
}

///|
test "InlineKeyboardButton from fixed JSON with callback_data" {
  let json = @json.parse(
    (
      #|{"text":"Press me","callback_data":"action_42"}
    ),
  )
  let btn : InlineKeyboardButton = @json.from_json(json)
  inspect(btn.text, content="Press me")
  inspect(btn.callback_data, content="Some(\"action_42\")")
  inspect(btn.url, content="None")
}

///|
test "InlineKeyboardMarkup from fixed JSON" {
  let json = @json.parse(
    (
      #|{"inline_keyboard":[[{"text":"Yes","callback_data":"yes"},{"text":"No","callback_data":"no"}],[{"text":"Visit","url":"https://example.com"}]]}
    ),
  )
  let markup : InlineKeyboardMarkup = @json.from_json(json)
  inspect(markup.inline_keyboard.length(), content="2")
  inspect(markup.inline_keyboard[0].length(), content="2")
  inspect(markup.inline_keyboard[0][0].text, content="Yes")
  inspect(markup.inline_keyboard[0][0].callback_data, content="Some(\"yes\")")
  inspect(markup.inline_keyboard[0][1].text, content="No")
  inspect(markup.inline_keyboard[1][0].text, content="Visit")
  inspect(
    markup.inline_keyboard[1][0].url,
    content="Some(\"https://example.com\")",
  )
  inspect(markup.inline_keyboard[1][0].callback_data, content="None")
}
