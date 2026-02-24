///|
test "DirectMessagesTopic JSON round-trip" {
  let original = DirectMessagesTopic::new(
    id=123,
    name="Support",
    icon_color=16711680,
  )
  let json = original.to_json()
  let decoded : DirectMessagesTopic = @json.from_json(json)
  inspect(decoded.id, content="123")
  inspect(decoded.name, content="Support")
  inspect(decoded.icon_color, content="16711680")
}

///|
test "DirectMessagesTopic ToJson and FromJson" {
  let topic = DirectMessagesTopic::new(id=456, name="General", icon_color=65280)
  let json = topic.to_json()
  let reconstructed : DirectMessagesTopic = @json.from_json(json)
  inspect(reconstructed.id, content="456")
  inspect(reconstructed.name, content="General")
  inspect(reconstructed.icon_color, content="65280")
}

///|
test "DirectMessagesTopic from fixed JSON" {
  let json = @json.parse(
    (
      #|{"id":1,"name":"Support","icon_color":16711680}
    ),
  )
  let topic : DirectMessagesTopic = @json.from_json(json)
  inspect(topic.id, content="1")
  inspect(topic.name, content="Support")
  inspect(topic.icon_color, content="16711680")
}

///|
test "DirectMessagesTopic from fixed JSON blue icon" {
  let json = @json.parse(
    (
      #|{"id":7,"name":"General","icon_color":255}
    ),
  )
  let topic : DirectMessagesTopic = @json.from_json(json)
  inspect(topic.id, content="7")
  inspect(topic.name, content="General")
  inspect(topic.icon_color, content="255")
}
