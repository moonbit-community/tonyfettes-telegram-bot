///|
test "User JSON round-trip" {
  let user : User = User::new(
    id=123L,
    is_bot=true,
    first_name="TestBot",
    username="test_bot",
  )
  let json = @json.to_json(user)
  let parsed : User = @json.from_json(json)
  inspect(parsed.id, content="123")
  inspect(parsed.is_bot, content="true")
  inspect(parsed.first_name, content="TestBot")
  inspect(parsed.username, content="Some(\"test_bot\")")
}

///|
test "User from fixed JSON" {
  let json = @json.parse(
    #|{"id":123,"is_bot":true,"first_name":"TestBot","username":"test_bot"}
  )
  let user : User = @json.from_json(json)
  inspect(user.id, content="123")
  inspect(user.is_bot, content="true")
  inspect(user.first_name, content="TestBot")
  inspect(user.username, content="Some(\"test_bot\")")
  inspect(user.last_name, content="None")
  inspect(user.language_code, content="None")
}
