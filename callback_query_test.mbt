///|
test "CallbackQuery JSON round-trip" {
  let query = CallbackQuery::new(
    id="123456789",
    from=User::new(id=123L, is_bot=false, first_name="John"),
    message=Message::new(
      message_id=789,
      date=1640000000,
      chat=Chat::new(id=456L, type_=Private),
    ),
    chat_instance="987654321",
    data="button_clicked",
  )
  let json = @json.to_json(query)
  let parsed : CallbackQuery = @json.from_json(json)
  inspect(parsed.id, content="123456789")
  inspect(parsed.from.first_name, content="John")
  inspect(parsed.chat_instance, content="987654321")
  inspect(parsed.data, content="Some(\"button_clicked\")")
  inspect(parsed.message is None, content="false")
}

///|
test "CallbackQuery without message JSON round-trip" {
  let query = CallbackQuery::new(
    id="123456789",
    from=User::new(id=123L, is_bot=false, first_name="Jane"),
    inline_message_id="inline_123",
    chat_instance="987654321",
    data="inline_button",
  )
  let json = @json.to_json(query)
  let parsed : CallbackQuery = @json.from_json(json)
  inspect(parsed.id, content="123456789")
  inspect(parsed.message, content="None")
  inspect(parsed.inline_message_id, content="Some(\"inline_123\")")
}

///|
test "CallbackQuery from fixed JSON with data" {
  let json = @json.parse(
    (
      #|{"id":"abc123","from":{"id":123,"is_bot":false,"first_name":"John"},"chat_instance":"xyz789","data":"button_data"}
    ),
  )
  let cq : CallbackQuery = @json.from_json(json)
  inspect(cq.id, content="abc123")
  inspect(cq.from.id, content="123")
  inspect(cq.from.first_name, content="John")
  inspect(cq.from.is_bot, content="false")
  inspect(cq.chat_instance, content="xyz789")
  inspect(cq.data, content="Some(\"button_data\")")
  inspect(cq.message, content="None")
  inspect(cq.inline_message_id, content="None")
}

///|
test "CallbackQuery from fixed JSON with inline_message_id" {
  let json = @json.parse(
    (
      #|{"id":"cq_inline_01","from":{"id":55667788,"is_bot":false,"first_name":"Eve","username":"eve99"},"inline_message_id":"inline_msg_xyz","chat_instance":"chat_inst_001"}
    ),
  )
  let cq : CallbackQuery = @json.from_json(json)
  inspect(cq.id, content="cq_inline_01")
  inspect(cq.from.id, content="55667788")
  inspect(cq.from.username, content="Some(\"eve99\")")
  inspect(cq.inline_message_id, content="Some(\"inline_msg_xyz\")")
  inspect(cq.data, content="None")
  inspect(cq.message, content="None")
}

///|
test "CallbackQuery from fixed JSON with message" {
  let json = @json.parse(
    (
      #|{"id":"cq_msg_01","from":{"id":11223344,"is_bot":false,"first_name":"Dave"},"chat_instance":"inst_abc","message":{"message_id":42,"date":1700000000,"chat":{"id":99887766,"type":"private"}},"data":"confirm"}
    ),
  )
  let cq : CallbackQuery = @json.from_json(json)
  inspect(cq.id, content="cq_msg_01")
  inspect(cq.chat_instance, content="inst_abc")
  inspect(cq.data, content="Some(\"confirm\")")
  guard cq.message is Some(m) else { fail("Expected message") }
  inspect(m.message_id, content="42")
  inspect(m.chat.id, content="99887766")
}
