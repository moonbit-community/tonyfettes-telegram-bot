///|
test "WebAppInfo JSON round-trip" {
  let web_app = WebAppInfo::new(url="https://example.com/app")
  let json = @json.to_json(web_app)
  let parsed : WebAppInfo = @json.from_json(json)
  inspect(parsed.url, content="https://example.com/app")
}

///|
test "KeyboardButtonPollType JSON round-trip with type" {
  let poll_type = KeyboardButtonPollType::new(type_="quiz")
  let json = @json.to_json(poll_type)
  let parsed : KeyboardButtonPollType = @json.from_json(json)
  inspect(parsed.type_, content="Some(\"quiz\")")
}

///|
test "KeyboardButtonPollType JSON round-trip without type" {
  let poll_type = KeyboardButtonPollType::new()
  let json = @json.to_json(poll_type)
  let parsed : KeyboardButtonPollType = @json.from_json(json)
  inspect(parsed.type_, content="None")
}

///|
test "KeyboardButtonRequestUsers JSON round-trip" {
  let request = KeyboardButtonRequestUsers::new(
    request_id=1,
    user_is_bot=true,
    max_quantity=5,
  )
  let json = @json.to_json(request)
  let parsed : KeyboardButtonRequestUsers = @json.from_json(json)
  inspect(parsed.request_id, content="1")
  inspect(parsed.user_is_bot, content="Some(true)")
  inspect(parsed.user_is_premium, content="None")
  inspect(parsed.max_quantity, content="Some(5)")
  inspect(parsed.request_name, content="None")
}

///|
test "KeyboardButtonRequestChat JSON round-trip" {
  let request = KeyboardButtonRequestChat::new(
    request_id=2,
    chat_is_channel=false,
    chat_is_forum=true,
    bot_is_member=true,
  )
  let json = @json.to_json(request)
  let parsed : KeyboardButtonRequestChat = @json.from_json(json)
  inspect(parsed.request_id, content="2")
  inspect(parsed.chat_is_channel, content="false")
  inspect(parsed.chat_is_forum, content="Some(true)")
  inspect(parsed.chat_has_username, content="None")
  inspect(parsed.bot_is_member, content="Some(true)")
}

///|
test "KeyboardButton simple JSON round-trip" {
  let button = KeyboardButton::new(text="Send Contact", request_contact=true)
  let json = @json.to_json(button)
  let parsed : KeyboardButton = @json.from_json(json)
  inspect(parsed.text, content="Send Contact")
  inspect(parsed.request_contact, content="Some(true)")
  inspect(parsed.request_location, content="None")
}

///|
test "KeyboardButton with request_users JSON round-trip" {
  let button = KeyboardButton::new(
    text="Select User",
    request_users=KeyboardButtonRequestUsers::new(request_id=1, max_quantity=3),
  )
  let json = @json.to_json(button)
  let parsed : KeyboardButton = @json.from_json(json)
  inspect(parsed.text, content="Select User")
  guard parsed.request_users is Some(ru) else {
    fail("Expected request_users to be Some")
  }
  inspect(ru.request_id, content="1")
  inspect(ru.max_quantity, content="Some(3)")
}

///|
test "KeyboardButton with web_app JSON round-trip" {
  let button = KeyboardButton::new(
    text="Open App",
    web_app=WebAppInfo::new(url="https://example.com/webapp"),
  )
  let json = @json.to_json(button)
  let parsed : KeyboardButton = @json.from_json(json)
  inspect(parsed.text, content="Open App")
  guard parsed.web_app is Some(wa) else { fail("Expected web_app to be Some") }
  inspect(wa.url, content="https://example.com/webapp")
}

///|
test "KeyboardButtonPollType from fixed JSON" {
  let json = @json.parse(
    #|{"type":"quiz"}
  )
  let poll_type : KeyboardButtonPollType = @json.from_json(json)
  inspect(poll_type.type_, content="Some(\"quiz\")")
}

///|
test "KeyboardButtonPollType from fixed JSON without type" {
  let json = @json.parse(
    #|{}
  )
  let poll_type : KeyboardButtonPollType = @json.from_json(json)
  inspect(poll_type.type_, content="None")
}

///|
test "KeyboardButtonRequestUsers from fixed JSON" {
  let json = @json.parse(
    #|{"request_id":7,"user_is_bot":false,"max_quantity":3}
  )
  let req : KeyboardButtonRequestUsers = @json.from_json(json)
  inspect(req.request_id, content="7")
  inspect(req.user_is_bot, content="Some(false)")
  inspect(req.user_is_premium, content="None")
  inspect(req.max_quantity, content="Some(3)")
  inspect(req.request_name, content="None")
  inspect(req.request_username, content="None")
  inspect(req.request_photo, content="None")
}

///|
test "KeyboardButtonRequestChat from fixed JSON" {
  let json = @json.parse(
    #|{"request_id":3,"chat_is_channel":true,"chat_is_forum":false,"request_title":true}
  )
  let req : KeyboardButtonRequestChat = @json.from_json(json)
  inspect(req.request_id, content="3")
  inspect(req.chat_is_channel, content="true")
  inspect(req.chat_is_forum, content="Some(false)")
  inspect(req.chat_has_username, content="None")
  inspect(req.bot_is_member, content="None")
  inspect(req.request_title, content="Some(true)")
  inspect(req.request_username, content="None")
  inspect(req.request_photo, content="None")
}

///|
test "KeyboardButton from fixed JSON simple" {
  let json = @json.parse(
    #|{"text":"Share Location","request_location":true}
  )
  let btn : KeyboardButton = @json.from_json(json)
  inspect(btn.text, content="Share Location")
  inspect(btn.request_location, content="Some(true)")
  inspect(btn.request_contact, content="None")
  inspect(btn.request_poll, content="None")
  inspect(btn.web_app, content="None")
}

///|
test "KeyboardButton from fixed JSON with request_poll" {
  let json = @json.parse(
    #|{"text":"Vote","request_poll":{"type":"regular"}}
  )
  let btn : KeyboardButton = @json.from_json(json)
  inspect(btn.text, content="Vote")
  guard btn.request_poll is Some(rp) else {
    fail("Expected request_poll to be Some")
  }
  inspect(rp.type_, content="Some(\"regular\")")
  inspect(btn.request_contact, content="None")
}

///|
test "KeyboardButton from fixed JSON with web_app" {
  let json = @json.parse(
    #|{"text":"Launch","web_app":{"url":"https://myapp.example.com"}}
  )
  let btn : KeyboardButton = @json.from_json(json)
  inspect(btn.text, content="Launch")
  guard btn.web_app is Some(wa) else { fail("Expected web_app to be Some") }
  inspect(wa.url, content="https://myapp.example.com")
  inspect(btn.request_users, content="None")
  inspect(btn.request_chat, content="None")
}
