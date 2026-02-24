///|
test "Message JSON round-trip" {
  let message : Message = Message::new(
    message_id=789,
    from=@bot.User::new(
      id=123L,
      is_bot=false,
      first_name="John",
      last_name="Doe",
      username="johndoe",
      language_code="en",
    ),
    date=1640000000,
    chat=Chat::new(
      id=456L,
      type_=Private,
      username="johndoe",
      first_name="John",
      last_name="Doe",
    ),
    text="Hello, world!",
  )
  let json = @json.to_json(message)
  let parsed : Message = @json.from_json(json)
  inspect(parsed.message_id, content="789")
  inspect(parsed.text, content="Some(\"Hello, world!\")")
}

///|
test "Message with new fields JSON round-trip" {
  let direct_messages_topic = DirectMessagesTopic::new(
    id=1,
    name="Support",
    icon_color=16711680,
  )
  let sticker = StickerPlaceholder::new(
    file_id="abc123",
    file_unique_id="unique123",
    width=512,
    height=512,
  )
  let gift = Gift::new(id="gift_id_123", sticker~, star_count=100)
  let gift_info = GiftInfo::new(gift~)
  let message : Message = Message::new(
    message_id=790,
    date=1640000001,
    chat=Chat::new(
      id=457L,
      type_=Private,
      username="janedoe",
      first_name="Jane",
      last_name="Doe",
    ),
    text="Test message with new fields",
    message_thread_id=5,
    is_topic_message=true,
    direct_messages_topic~,
    gift_upgrade_sent=gift_info,
    gift_id="gift_123",
    is_from_blockchain=true,
  )
  let json = @json.to_json(message)
  let parsed : Message = @json.from_json(json)
  inspect(parsed.message_id, content="790")
  inspect(parsed.message_thread_id, content="Some(5)")
  inspect(parsed.is_topic_message, content="Some(true)")
  inspect(parsed.gift_id, content="Some(\"gift_123\")")
  inspect(parsed.is_from_blockchain, content="Some(true)")
}

///|
test "Message with direct_messages_topic field" {
  let direct_messages_topic = DirectMessagesTopic::new(
    id=2,
    name="General",
    icon_color=65280,
  )
  let message : Message = Message::new(
    message_id=791,
    date=1640000002,
    chat=Chat::new(id=458L, type_=Private, username="bob", first_name="Bob"),
    text="Message with topic",
    direct_messages_topic~,
  )
  let json = @json.to_json(message)
  let reconstructed : Message = @json.from_json(json)
  inspect(reconstructed.direct_messages_topic is Some(_), content="true")
  guard reconstructed.direct_messages_topic is Some(topic) else { return }
  inspect(topic.id, content="2")
  inspect(topic.name, content="General")
  inspect(topic.icon_color, content="65280")
}

///|
test "MessageEntity from fixed JSON" {
  let json = @json.parse(
    #|{"type":"bold","offset":0,"length":4}
  )
  let entity : MessageEntity = @json.from_json(json)
  inspect(entity.type_, content="bold")
  inspect(entity.offset, content="0")
  inspect(entity.length, content="4")
  inspect(entity.url, content="None")
  inspect(entity.user, content="None")
  inspect(entity.language, content="None")
}

///|
test "MessageEntity with optional fields from fixed JSON" {
  let json = @json.parse(
    #|{"type":"text_link","offset":5,"length":10,"url":"https://example.com","language":"en"}
  )
  let entity : MessageEntity = @json.from_json(json)
  inspect(entity.type_, content="text_link")
  inspect(entity.offset, content="5")
  inspect(entity.length, content="10")
  inspect(entity.url, content="Some(\"https://example.com\")")
  inspect(entity.language, content="Some(\"en\")")
}

///|
test "Message from fixed JSON" {
  let json = @json.parse(
    #|{"message_id":1,"date":1234567890,"chat":{"id":456,"type":"private"}}
  )
  let msg : Message = @json.from_json(json)
  inspect(msg.message_id, content="1")
  inspect(msg.date, content="1234567890")
  inspect(msg.chat.id, content="456")
  inspect(msg.chat.type_, content="Private")
  inspect(msg.text, content="None")
  inspect(msg.from, content="None")
  inspect(msg.entities, content="None")
}

///|
test "Message with text and from from fixed JSON" {
  let json = @json.parse(
    #|{"message_id":42,"date":1700000000,"chat":{"id":100,"type":"group","title":"My Group"},"from":{"id":999,"is_bot":false,"first_name":"Alice","username":"alice"},"text":"Hello world"}
  )
  let msg : Message = @json.from_json(json)
  inspect(msg.message_id, content="42")
  inspect(msg.date, content="1700000000")
  inspect(msg.chat.id, content="100")
  inspect(msg.chat.type_, content="Group")
  inspect(msg.chat.title, content="Some(\"My Group\")")
  inspect(msg.text, content="Some(\"Hello world\")")
  guard msg.from is Some(user) else { fail("Expected from") }
  inspect(user.id, content="999")
  inspect(user.first_name, content="Alice")
  inspect(user.username, content="Some(\"alice\")")
  inspect(msg.reply_to_message, content="None")
  inspect(msg.message_thread_id, content="None")
}

///|
test "Message with entities from fixed JSON" {
  let json = @json.parse(
    #|{"message_id":7,"date":1700001000,"chat":{"id":200,"type":"private"},"text":"bold text","entities":[{"type":"bold","offset":0,"length":4}]}
  )
  let msg : Message = @json.from_json(json)
  inspect(msg.message_id, content="7")
  inspect(msg.text, content="Some(\"bold text\")")
  guard msg.entities is Some(entities) else { fail("Expected entities") }
  inspect(entities.length(), content="1")
  inspect(entities[0].type_, content="bold")
  inspect(entities[0].offset, content="0")
  inspect(entities[0].length, content="4")
}
