///|
test "MessageOriginUser JSON round-trip" {
  let user = User::new(id=123L, is_bot=false, first_name="John")
  let origin : MessageOrigin = User(
    MessageOriginUser::new(date=1609459200, sender_user=user),
  )
  let json = origin.to_json()
  let parsed : MessageOrigin = @json.from_json(json)
  guard parsed is User(v) else { fail("Expected MessageOrigin::User") }
  inspect(v.date, content="1609459200")
  inspect(v.sender_user.first_name, content="John")
}

///|
test "MessageOriginHiddenUser JSON round-trip" {
  let origin : MessageOrigin = HiddenUser(
    MessageOriginHiddenUser::new(date=1609459200, sender_user_name="Anonymous"),
  )
  let json = origin.to_json()
  let parsed : MessageOrigin = @json.from_json(json)
  guard parsed is HiddenUser(v) else {
    fail("Expected MessageOrigin::HiddenUser")
  }
  inspect(v.date, content="1609459200")
  inspect(v.sender_user_name, content="Anonymous")
}

///|
test "MessageOriginChat JSON round-trip" {
  let chat = Chat::new(id=456L, type_=Group, title="Test Group")
  let origin : MessageOrigin = Chat(
    MessageOriginChat::new(
      date=1609459200,
      sender_chat=chat,
      author_signature="Admin",
    ),
  )
  let json = origin.to_json()
  let parsed : MessageOrigin = @json.from_json(json)
  guard parsed is Chat(v) else { fail("Expected MessageOrigin::Chat") }
  inspect(v.date, content="1609459200")
  inspect(v.sender_chat.id, content="456")
  inspect(v.author_signature, content="Some(\"Admin\")")
}

///|
test "MessageOriginChat without author_signature" {
  let chat = Chat::new(id=789L, type_=Supergroup, title="Super Group")
  let origin : MessageOrigin = Chat(
    MessageOriginChat::new(date=1609459200, sender_chat=chat),
  )
  let json = origin.to_json()
  let parsed : MessageOrigin = @json.from_json(json)
  guard parsed is Chat(v) else { fail("Expected MessageOrigin::Chat") }
  inspect(v.author_signature, content="None")
}

///|
test "MessageOriginChannel JSON round-trip" {
  let chat = Chat::new(id=100L, type_=Channel, title="News Channel")
  let origin : MessageOrigin = Channel(
    MessageOriginChannel::new(
      date=1609459200,
      chat~,
      message_id=42,
      author_signature="Editor",
    ),
  )
  let json = origin.to_json()
  let parsed : MessageOrigin = @json.from_json(json)
  guard parsed is Channel(v) else { fail("Expected MessageOrigin::Channel") }
  inspect(v.date, content="1609459200")
  inspect(v.chat.id, content="100")
  inspect(v.message_id, content="42")
  inspect(v.author_signature, content="Some(\"Editor\")")
}

///|
test "MessageOriginChannel without author_signature" {
  let chat = Chat::new(id=200L, type_=Channel, title="Tech News")
  let origin : MessageOrigin = Channel(
    MessageOriginChannel::new(date=1609459200, chat~, message_id=99),
  )
  let json = origin.to_json()
  let parsed : MessageOrigin = @json.from_json(json)
  guard parsed is Channel(v) else { fail("Expected MessageOrigin::Channel") }
  inspect(v.author_signature, content="None")
}

///|
test "MessageOrigin::User from fixed JSON" {
  let json = @json.parse(
    (
      #|{"type":"user","date":1700000000,"sender_user":{"id":123,"is_bot":false,"first_name":"Alice"}}
    ),
  )
  let origin : MessageOrigin = @json.from_json(json)
  guard origin is User(v) else { fail("Expected MessageOrigin::User") }
  inspect(v.date, content="1700000000")
  inspect(v.sender_user.id, content="123")
  inspect(v.sender_user.first_name, content="Alice")
}

///|
test "MessageOrigin::HiddenUser from fixed JSON" {
  let json = @json.parse(
    (
      #|{"type":"hidden_user","date":1700000001,"sender_user_name":"SomeAnonymous"}
    ),
  )
  let origin : MessageOrigin = @json.from_json(json)
  guard origin is HiddenUser(v) else {
    fail("Expected MessageOrigin::HiddenUser")
  }
  inspect(v.date, content="1700000001")
  inspect(v.sender_user_name, content="SomeAnonymous")
}

///|
test "MessageOrigin::Chat from fixed JSON with author_signature" {
  let json = @json.parse(
    (
      #|{"type":"chat","date":1700000002,"sender_chat":{"id":456,"type":"group","title":"MyGroup"},"author_signature":"Editor"}
    ),
  )
  let origin : MessageOrigin = @json.from_json(json)
  guard origin is Chat(v) else { fail("Expected MessageOrigin::Chat") }
  inspect(v.date, content="1700000002")
  inspect(v.sender_chat.id, content="456")
  inspect(v.author_signature, content="Some(\"Editor\")")
}

///|
test "MessageOrigin::Chat from fixed JSON without author_signature" {
  let json = @json.parse(
    (
      #|{"type":"chat","date":1700000003,"sender_chat":{"id":789,"type":"supergroup","title":"BigGroup"}}
    ),
  )
  let origin : MessageOrigin = @json.from_json(json)
  guard origin is Chat(v) else { fail("Expected MessageOrigin::Chat") }
  inspect(v.sender_chat.id, content="789")
  inspect(v.author_signature, content="None")
}

///|
test "MessageOrigin::Channel from fixed JSON" {
  let json = @json.parse(
    (
      #|{"type":"channel","date":1700000004,"chat":{"id":1001,"type":"channel","title":"NewsChannel"},"message_id":55,"author_signature":"Reporter"}
    ),
  )
  let origin : MessageOrigin = @json.from_json(json)
  guard origin is Channel(v) else { fail("Expected MessageOrigin::Channel") }
  inspect(v.date, content="1700000004")
  inspect(v.chat.id, content="1001")
  inspect(v.message_id, content="55")
  inspect(v.author_signature, content="Some(\"Reporter\")")
}

///|
test "MessageOrigin::Channel from fixed JSON without author_signature" {
  let json = @json.parse(
    (
      #|{"type":"channel","date":1700000005,"chat":{"id":2002,"type":"channel","title":"TechNews"},"message_id":99}
    ),
  )
  let origin : MessageOrigin = @json.from_json(json)
  guard origin is Channel(v) else { fail("Expected MessageOrigin::Channel") }
  inspect(v.chat.id, content="2002")
  inspect(v.message_id, content="99")
  inspect(v.author_signature, content="None")
}
