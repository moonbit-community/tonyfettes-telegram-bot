///|
test "BotCommandScope Default JSON round-trip" {
  let object : BotCommandScope = Default
  let json = object.to_json()
  let parsed : BotCommandScope = @json.from_json(json)
  inspect(parsed, content="Default")
}

///|
test "BotCommandScope AllPrivateChats JSON round-trip" {
  let object : BotCommandScope = AllPrivateChats
  let json = object.to_json()
  let parsed : BotCommandScope = @json.from_json(json)
  inspect(parsed, content="AllPrivateChats")
}

///|
test "BotCommandScope AllGroupChats JSON round-trip" {
  let object : BotCommandScope = AllGroupChats
  let json = object.to_json()
  let parsed : BotCommandScope = @json.from_json(json)
  inspect(parsed, content="AllGroupChats")
}

///|
test "BotCommandScope AllChatAdministrators JSON round-trip" {
  let object : BotCommandScope = AllChatAdministrators
  let json = object.to_json()
  let parsed : BotCommandScope = @json.from_json(json)
  inspect(parsed, content="AllChatAdministrators")
}

///|
test "BotCommandScope Chat JSON round-trip" {
  let object : BotCommandScope = Chat({ chat_id: 123L })
  let json = object.to_json()
  let parsed : BotCommandScope = @json.from_json(json)
  guard parsed is Chat(v) else { fail("Expected Chat") }
  inspect(v.chat_id, content="123")
}

///|
test "BotCommandScope ChatAdministrators JSON round-trip" {
  let object : BotCommandScope = ChatAdministrators({ chat_id: 456L })
  let json = object.to_json()
  let parsed : BotCommandScope = @json.from_json(json)
  guard parsed is ChatAdministrators(v) else {
    fail("Expected ChatAdministrators")
  }
  inspect(v.chat_id, content="456")
}

///|
test "BotCommandScope ChatMember JSON round-trip" {
  let object : BotCommandScope = ChatMember({ chat_id: 123L, user_id: 456L })
  let json = object.to_json()
  let parsed : BotCommandScope = @json.from_json(json)
  guard parsed is ChatMember(v) else { fail("Expected ChatMember") }
  inspect(v.chat_id, content="123")
  inspect(v.user_id, content="456")
}

///|
test "BotCommandScopeChat new constructor" {
  let object = BotCommandScopeChat::new(chat_id=789L)
  inspect(object.chat_id, content="789")
}

///|
test "BotCommandScopeChatAdministrators new constructor" {
  let object = BotCommandScopeChatAdministrators::new(chat_id=789L)
  inspect(object.chat_id, content="789")
}

///|
test "BotCommandScopeChatMember new constructor" {
  let object = BotCommandScopeChatMember::new(chat_id=123L, user_id=456L)
  inspect(object.chat_id, content="123")
  inspect(object.user_id, content="456")
}

///|
test "BotCommandScope::Default from fixed JSON" {
  let json = @json.parse(
    (
      #|{"type":"default"}
    ),
  )
  let scope : BotCommandScope = @json.from_json(json)
  guard scope is Default else { fail("Expected Default") }
}

///|
test "BotCommandScope::AllPrivateChats from fixed JSON" {
  let json = @json.parse(
    (
      #|{"type":"all_private_chats"}
    ),
  )
  let scope : BotCommandScope = @json.from_json(json)
  guard scope is AllPrivateChats else { fail("Expected AllPrivateChats") }
}

///|
test "BotCommandScope::AllGroupChats from fixed JSON" {
  let json = @json.parse(
    (
      #|{"type":"all_group_chats"}
    ),
  )
  let scope : BotCommandScope = @json.from_json(json)
  guard scope is AllGroupChats else { fail("Expected AllGroupChats") }
}

///|
test "BotCommandScope::AllChatAdministrators from fixed JSON" {
  let json = @json.parse(
    (
      #|{"type":"all_chat_administrators"}
    ),
  )
  let scope : BotCommandScope = @json.from_json(json)
  guard scope is AllChatAdministrators else {
    fail("Expected AllChatAdministrators")
  }
}

///|
test "BotCommandScope::Chat from fixed JSON" {
  let json = @json.parse(
    (
      #|{"type":"chat","chat_id":112233445}
    ),
  )
  let scope : BotCommandScope = @json.from_json(json)
  guard scope is Chat(v) else { fail("Expected Chat") }
  inspect(v.chat_id, content="112233445")
}

///|
test "BotCommandScope::ChatAdministrators from fixed JSON" {
  let json = @json.parse(
    (
      #|{"type":"chat_administrators","chat_id":998877665}
    ),
  )
  let scope : BotCommandScope = @json.from_json(json)
  guard scope is ChatAdministrators(v) else {
    fail("Expected ChatAdministrators")
  }
  inspect(v.chat_id, content="998877665")
}

///|
test "BotCommandScope::ChatMember from fixed JSON" {
  let json = @json.parse(
    (
      #|{"type":"chat_member","chat_id":111222333,"user_id":444555666}
    ),
  )
  let scope : BotCommandScope = @json.from_json(json)
  guard scope is ChatMember(v) else { fail("Expected ChatMember") }
  inspect(v.chat_id, content="111222333")
  inspect(v.user_id, content="444555666")
}
