///|
test "PhotoSize JSON round-trip" {
  let photo = PhotoSize::new(
    file_id="photo123",
    file_unique_id="unique456",
    width=640,
    height=480,
  )
  let json = @json.to_json(photo)
  let parsed : PhotoSize = @json.from_json(json)
  inspect(parsed.file_id, content="photo123")
  inspect(parsed.file_unique_id, content="unique456")
  inspect(parsed.width, content="640")
  inspect(parsed.height, content="480")
}

///|
test "SharedUser JSON round-trip" {
  let user = SharedUser::new(
    user_id=12345L,
    first_name="John",
    last_name="Doe",
    username="johndoe",
  )
  let json = @json.to_json(user)
  let parsed : SharedUser = @json.from_json(json)
  inspect(parsed.user_id, content="12345")
  inspect(parsed.first_name, content="Some(\"John\")")
  inspect(parsed.last_name, content="Some(\"Doe\")")
  inspect(parsed.username, content="Some(\"johndoe\")")
  inspect(parsed.photo, content="None")
}

///|
test "SharedUser with photo JSON round-trip" {
  let photo = PhotoSize::new(
    file_id="photo123",
    file_unique_id="unique456",
    width=640,
    height=480,
  )
  let user = SharedUser::new(user_id=67890L, photo=[photo])
  let json = @json.to_json(user)
  let parsed : SharedUser = @json.from_json(json)
  inspect(parsed.user_id, content="67890")
  inspect(parsed.first_name, content="None")
  guard parsed.photo is Some(photos) else { fail("Expected photo array") }
  inspect(photos.length(), content="1")
  inspect(photos[0].file_id, content="photo123")
}

///|
test "UsersShared JSON round-trip" {
  let user1 = SharedUser::new(user_id=111L, first_name="Alice")
  let user2 = SharedUser::new(user_id=222L, first_name="Bob")
  let shared = UsersShared::new(request_id=42, users=[user1, user2])
  let json = @json.to_json(shared)
  let parsed : UsersShared = @json.from_json(json)
  inspect(parsed.request_id, content="42")
  inspect(parsed.users.length(), content="2")
  inspect(parsed.users[0].user_id, content="111")
  inspect(parsed.users[1].user_id, content="222")
}

///|
test "ChatShared JSON round-trip" {
  let shared = ChatShared::new(
    request_id=99,
    chat_id=123456L,
    title="My Group",
    username="mygroup",
  )
  let json = @json.to_json(shared)
  let parsed : ChatShared = @json.from_json(json)
  inspect(parsed.request_id, content="99")
  inspect(parsed.chat_id, content="123456")
  inspect(parsed.title, content="Some(\"My Group\")")
  inspect(parsed.username, content="Some(\"mygroup\")")
  inspect(parsed.photo, content="None")
}

///|
test "ChatShared minimal JSON round-trip" {
  let shared = ChatShared::new(request_id=1, chat_id=789L)
  let json = @json.to_json(shared)
  let parsed : ChatShared = @json.from_json(json)
  inspect(parsed.request_id, content="1")
  inspect(parsed.chat_id, content="789")
  inspect(parsed.title, content="None")
  inspect(parsed.username, content="None")
  inspect(parsed.photo, content="None")
}

///|
test "SharedUser from fixed JSON" {
  let json = @json.parse(
    #|{"user_id":12345,"first_name":"John","username":"johndoe"}
  )
  let user : SharedUser = @json.from_json(json)
  inspect(user.user_id, content="12345")
  inspect(user.first_name, content="Some(\"John\")")
  inspect(user.last_name, content="None")
  inspect(user.username, content="Some(\"johndoe\")")
  inspect(user.photo, content="None")
}

///|
test "UsersShared from fixed JSON" {
  let json = @json.parse(
    #|{"request_id":42,"users":[{"user_id":111,"first_name":"Alice"},{"user_id":222,"first_name":"Bob"}]}
  )
  let shared : UsersShared = @json.from_json(json)
  inspect(shared.request_id, content="42")
  inspect(shared.users.length(), content="2")
  inspect(shared.users[0].user_id, content="111")
  inspect(shared.users[0].first_name, content="Some(\"Alice\")")
  inspect(shared.users[1].user_id, content="222")
  inspect(shared.users[1].first_name, content="Some(\"Bob\")")
}

///|
test "ChatShared from fixed JSON" {
  let json = @json.parse(
    #|{"request_id":99,"chat_id":123456,"title":"My Group","username":"mygroup"}
  )
  let shared : ChatShared = @json.from_json(json)
  inspect(shared.request_id, content="99")
  inspect(shared.chat_id, content="123456")
  inspect(shared.title, content="Some(\"My Group\")")
  inspect(shared.username, content="Some(\"mygroup\")")
  inspect(shared.photo, content="None")
}

///|
test "ChatShared from fixed JSON minimal" {
  let json = @json.parse(
    #|{"request_id":1,"chat_id":789}
  )
  let shared : ChatShared = @json.from_json(json)
  inspect(shared.request_id, content="1")
  inspect(shared.chat_id, content="789")
  inspect(shared.title, content="None")
  inspect(shared.username, content="None")
  inspect(shared.photo, content="None")
}
