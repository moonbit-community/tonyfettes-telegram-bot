///|
test "Story JSON round-trip" {
  let chat = Chat::new(id=123456L, type_=ChatType::Private, first_name="Alice")
  let story = Story::new(chat~, id=42)
  let json = story.to_json()
  let parsed : Story = @json.from_json(json)
  inspect(parsed.id, content="42")
  inspect(parsed.chat.id, content="123456")
  inspect(parsed.chat.type_, content="Private")
  inspect(parsed.chat.first_name, content="Some(\"Alice\")")
}

///|
test "Story with group chat JSON round-trip" {
  let chat = Chat::new(id=789L, type_=ChatType::Group, title="Test Group")
  let story = Story::new(chat~, id=100)
  let json = story.to_json()
  let parsed : Story = @json.from_json(json)
  inspect(parsed.id, content="100")
  inspect(parsed.chat.id, content="789")
  inspect(parsed.chat.type_, content="Group")
  inspect(parsed.chat.title, content="Some(\"Test Group\")")
}

///|
test "Story from fixed JSON with private chat" {
  let json = @json.parse(
    (
      #|{"chat":{"id":123456,"type":"private","first_name":"Alice"},"id":42}
    ),
  )
  let story : Story = @json.from_json(json)
  inspect(story.id, content="42")
  inspect(story.chat.id, content="123456")
  inspect(story.chat.type_, content="Private")
  inspect(story.chat.first_name, content="Some(\"Alice\")")
  inspect(story.chat.title, content="None")
}

///|
test "Story from fixed JSON with channel" {
  let json = @json.parse(
    (
      #|{"chat":{"id":-1001234567890,"type":"channel","title":"My Channel","username":"mychannel"},"id":7}
    ),
  )
  let story : Story = @json.from_json(json)
  inspect(story.id, content="7")
  inspect(story.chat.type_, content="Channel")
  inspect(story.chat.title, content="Some(\"My Channel\")")
  inspect(story.chat.username, content="Some(\"mychannel\")")
}
