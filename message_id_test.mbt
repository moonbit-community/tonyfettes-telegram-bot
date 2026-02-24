///|
test "MessageId JSON round-trip" {
  let msg_id = MessageId::new(message_id=12345)
  let json = msg_id.to_json()
  let parsed : MessageId = @json.from_json(json)
  inspect(parsed.message_id, content="12345")
}

///|
test "MessageId from fixed JSON" {
  let json = @json.parse(
    (
      #|{"message_id":42}
    ),
  )
  let msg_id : MessageId = @json.from_json(json)
  inspect(msg_id.message_id, content="42")
}

///|
test "MessageId from fixed JSON large id" {
  let json = @json.parse(
    (
      #|{"message_id":9999999}
    ),
  )
  let msg_id : MessageId = @json.from_json(json)
  inspect(msg_id.message_id, content="9999999")
}
