///|
test "ChatType JSON round-trip" {
  let types : Array[ChatType] = [Private, Group, Supergroup, Channel]
  for ct in types {
    let json = @json.to_json(ct)
    let parsed : ChatType = @json.from_json(json)
    inspect(ct == parsed, content="true")
  }
}

///|
test "Chat JSON round-trip" {
  let chat : Chat = Chat::new(
    id=456L,
    type_=Private,
    username=("testuser"),
    first_name=("Test"),
    last_name=("User"),
  )
  let json = @json.to_json(chat)
  let parsed : Chat = @json.from_json(json)
  inspect(parsed.id, content="456")
  inspect(parsed.type_, content="Private")
  inspect(parsed.username, content="Some(\"testuser\")")
}

///|
test "ChatType from fixed JSON" {
  let json = @json.parse(
    #|"supergroup"
  )
  let ct : ChatType = @json.from_json(json)
  inspect(ct, content="Supergroup")
}

///|
test "Chat from fixed JSON" {
  let json = @json.parse(
    #|{"id":456,"type":"group","title":"My Group","username":"mygroup"}
  )
  let chat : Chat = @json.from_json(json)
  inspect(chat.id, content="456")
  inspect(chat.type_, content="Group")
  inspect(chat.title, content="Some(\"My Group\")")
  inspect(chat.username, content="Some(\"mygroup\")")
  inspect(chat.first_name, content="None")
  inspect(chat.last_name, content="None")
}
