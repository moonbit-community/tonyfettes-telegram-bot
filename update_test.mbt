///|
test "Update JSON round-trip" {
  let update : Update = Update::new(
    update_id=100,
    message=Message::new(
      message_id=789,
      date=1640000000,
      chat=@bot.Chat::new(id=456L, type_=Group, title="Test Group"),
      text="Test message",
    ),
  )
  let json = update.to_json()
  let parsed : Update = @json.from_json(json)
  inspect(parsed.update_id, content="100")
  inspect(parsed.message is None, content="false")
}

///|
test "Update with callback_query JSON round-trip" {
  let update : Update = Update::new(
    update_id=101,
    callback_query=CallbackQuery::new(
      id="callback_123",
      from=User::new(id=123L, is_bot=false, first_name="Alice"),
      chat_instance="instance_456",
      data="button_action",
    ),
  )
  let json = update.to_json()
  let parsed : Update = @json.from_json(json)
  inspect(parsed.update_id, content="101")
  inspect(parsed.message, content="None")
  inspect(parsed.callback_query is None, content="false")
  inspect(
    parsed.callback_query.unwrap().data,
    content="Some(\"button_action\")",
  )
}

///|
test "Update from fixed JSON" {
  let json = @json.parse(
    (
      #|{"update_id":12345,"message":{"message_id":1,"date":1234567890,"chat":{"id":456,"type":"private"}}}
    ),
  )
  let upd : Update = @json.from_json(json)
  inspect(upd.update_id, content="12345")
  guard upd.message is Some(msg) else { fail("Expected message") }
  inspect(msg.message_id, content="1")
  inspect(msg.chat.id, content="456")
  inspect(msg.chat.type_, content="Private")
  inspect(upd.edited_message, content="None")
  inspect(upd.callback_query, content="None")
}

///|
test "Update with edited_message from fixed JSON" {
  let json = @json.parse(
    (
      #|{"update_id":99999,"edited_message":{"message_id":5,"date":1700000000,"chat":{"id":777,"type":"supergroup","title":"Big Group"},"text":"edited content"}}
    ),
  )
  let upd : Update = @json.from_json(json)
  inspect(upd.update_id, content="99999")
  inspect(upd.message, content="None")
  guard upd.edited_message is Some(msg) else { fail("Expected edited_message") }
  inspect(msg.message_id, content="5")
  inspect(msg.chat.type_, content="Supergroup")
  inspect(msg.text, content="Some(\"edited content\")")
}
