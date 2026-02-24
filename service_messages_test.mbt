///|
test "ForumTopicClosed JSON round-trip" {
  let object = ForumTopicClosed::new()
  let json = @json.to_json(object)
  let _parsed : ForumTopicClosed = @json.from_json(json)
}

///|
test "ForumTopicReopened JSON round-trip" {
  let object = ForumTopicReopened::new()
  let json = @json.to_json(object)
  let _parsed : ForumTopicReopened = @json.from_json(json)
}

///|
test "GeneralForumTopicHidden JSON round-trip" {
  let object = GeneralForumTopicHidden::new()
  let json = @json.to_json(object)
  let _parsed : GeneralForumTopicHidden = @json.from_json(json)
}

///|
test "GeneralForumTopicUnhidden JSON round-trip" {
  let object = GeneralForumTopicUnhidden::new()
  let json = @json.to_json(object)
  let _parsed : GeneralForumTopicUnhidden = @json.from_json(json)
}

///|
test "VideoChatStarted JSON round-trip" {
  let object = VideoChatStarted::new()
  let json = @json.to_json(object)
  let _parsed : VideoChatStarted = @json.from_json(json)
}

///|
test "VideoChatEnded JSON round-trip" {
  let object = VideoChatEnded::new(duration=300)
  let json = @json.to_json(object)
  let parsed : VideoChatEnded = @json.from_json(json)
  inspect(parsed.duration, content="300")
}

///|
test "VideoChatScheduled JSON round-trip" {
  let object = VideoChatScheduled::new(start_date=1640000000)
  let json = @json.to_json(object)
  let parsed : VideoChatScheduled = @json.from_json(json)
  inspect(parsed.start_date, content="1640000000")
}

///|
test "VideoChatParticipantsInvited JSON round-trip" {
  let user = User::new(id=12345L, is_bot=false, first_name="John")
  let object = VideoChatParticipantsInvited::new(users=[user])
  let json = @json.to_json(object)
  let parsed : VideoChatParticipantsInvited = @json.from_json(json)
  inspect(parsed.users[0].first_name, content="John")
}

///|
test "MessageAutoDeleteTimerChanged JSON round-trip" {
  let object = MessageAutoDeleteTimerChanged::new(
    message_auto_delete_time=86400,
  )
  let json = @json.to_json(object)
  let parsed : MessageAutoDeleteTimerChanged = @json.from_json(json)
  inspect(parsed.message_auto_delete_time, content="86400")
}

///|
test "ChatBoostAdded JSON round-trip" {
  let object = ChatBoostAdded::new(boost_count=5)
  let json = @json.to_json(object)
  let parsed : ChatBoostAdded = @json.from_json(json)
  inspect(parsed.boost_count, content="5")
}

///|
test "ProximityAlertTriggered JSON round-trip" {
  let traveler = User::new(id=111L, is_bot=false, first_name="Alice")
  let watcher = User::new(id=222L, is_bot=false, first_name="Bob")
  let object = ProximityAlertTriggered::new(traveler~, watcher~, distance=100)
  let json = @json.to_json(object)
  let parsed : ProximityAlertTriggered = @json.from_json(json)
  inspect(parsed.traveler.first_name, content="Alice")
  inspect(parsed.watcher.first_name, content="Bob")
  inspect(parsed.distance, content="100")
}

///|
test "WriteAccessAllowed JSON round-trip with all fields" {
  let object = WriteAccessAllowed::new(
    from_request=true,
    web_app_name="TestApp",
    from_attachment_menu=false,
  )
  let json = @json.to_json(object)
  let parsed : WriteAccessAllowed = @json.from_json(json)
  inspect(parsed.from_request, content="Some(true)")
  inspect(parsed.web_app_name, content="Some(\"TestApp\")")
  inspect(parsed.from_attachment_menu, content="Some(false)")
}

///|
test "WriteAccessAllowed JSON round-trip with no fields" {
  let object = WriteAccessAllowed::new()
  let json = @json.to_json(object)
  let parsed : WriteAccessAllowed = @json.from_json(json)
  inspect(parsed.from_request, content="None")
  inspect(parsed.web_app_name, content="None")
  inspect(parsed.from_attachment_menu, content="None")
}

///|
test "WebAppData JSON round-trip" {
  let object = WebAppData::new(data="test_data", button_text="Open App")
  let json = @json.to_json(object)
  let parsed : WebAppData = @json.from_json(json)
  inspect(parsed.data, content="test_data")
  inspect(parsed.button_text, content="Open App")
}

///|
test "ForumTopicClosed from fixed JSON" {
  let json = @json.parse(
    #|{}
  )
  let _parsed : ForumTopicClosed = @json.from_json(json)
}

///|
test "ForumTopicReopened from fixed JSON" {
  let json = @json.parse(
    #|{}
  )
  let _parsed : ForumTopicReopened = @json.from_json(json)
}

///|
test "GeneralForumTopicHidden from fixed JSON" {
  let json = @json.parse(
    #|{}
  )
  let _parsed : GeneralForumTopicHidden = @json.from_json(json)
}

///|
test "GeneralForumTopicUnhidden from fixed JSON" {
  let json = @json.parse(
    #|{}
  )
  let _parsed : GeneralForumTopicUnhidden = @json.from_json(json)
}

///|
test "VideoChatStarted from fixed JSON" {
  let json = @json.parse(
    #|{}
  )
  let _parsed : VideoChatStarted = @json.from_json(json)
}

///|
test "VideoChatEnded from fixed JSON" {
  let json = @json.parse(
    #|{"duration":1800}
  )
  let parsed : VideoChatEnded = @json.from_json(json)
  inspect(parsed.duration, content="1800")
}

///|
test "VideoChatScheduled from fixed JSON" {
  let json = @json.parse(
    #|{"start_date":1750000000}
  )
  let parsed : VideoChatScheduled = @json.from_json(json)
  inspect(parsed.start_date, content="1750000000")
}

///|
test "VideoChatParticipantsInvited from fixed JSON" {
  let json = @json.parse(
    #|{"users":[{"id":11111111,"is_bot":false,"first_name":"Carol"},{"id":22222222,"is_bot":true,"first_name":"BotFriend"}]}
  )
  let parsed : VideoChatParticipantsInvited = @json.from_json(json)
  inspect(parsed.users.length(), content="2")
  inspect(parsed.users[0].first_name, content="Carol")
  inspect(parsed.users[0].id, content="11111111")
  inspect(parsed.users[0].is_bot, content="false")
  inspect(parsed.users[1].first_name, content="BotFriend")
  inspect(parsed.users[1].is_bot, content="true")
}

///|
test "MessageAutoDeleteTimerChanged from fixed JSON" {
  let json = @json.parse(
    #|{"message_auto_delete_time":604800}
  )
  let parsed : MessageAutoDeleteTimerChanged = @json.from_json(json)
  inspect(parsed.message_auto_delete_time, content="604800")
}

///|
test "ChatBoostAdded from fixed JSON" {
  let json = @json.parse(
    #|{"boost_count":12}
  )
  let parsed : ChatBoostAdded = @json.from_json(json)
  inspect(parsed.boost_count, content="12")
}

///|
test "ProximityAlertTriggered from fixed JSON" {
  let json = @json.parse(
    #|{"traveler":{"id":55551111,"is_bot":false,"first_name":"Dave"},"watcher":{"id":55552222,"is_bot":false,"first_name":"Eve"},"distance":250}
  )
  let parsed : ProximityAlertTriggered = @json.from_json(json)
  inspect(parsed.traveler.first_name, content="Dave")
  inspect(parsed.traveler.id, content="55551111")
  inspect(parsed.watcher.first_name, content="Eve")
  inspect(parsed.watcher.id, content="55552222")
  inspect(parsed.distance, content="250")
}

///|
test "WriteAccessAllowed from fixed JSON with web_app_name" {
  let json = @json.parse(
    #|{"from_request":true,"web_app_name":"MyWebApp"}
  )
  let parsed : WriteAccessAllowed = @json.from_json(json)
  inspect(parsed.from_request, content="Some(true)")
  inspect(parsed.web_app_name, content="Some(\"MyWebApp\")")
  inspect(parsed.from_attachment_menu, content="None")
}

///|
test "WriteAccessAllowed from fixed JSON empty" {
  let json = @json.parse(
    #|{}
  )
  let parsed : WriteAccessAllowed = @json.from_json(json)
  inspect(parsed.from_request, content="None")
  inspect(parsed.web_app_name, content="None")
  inspect(parsed.from_attachment_menu, content="None")
}

///|
test "WriteAccessAllowed from fixed JSON from_attachment_menu" {
  let json = @json.parse(
    #|{"from_attachment_menu":true}
  )
  let parsed : WriteAccessAllowed = @json.from_json(json)
  inspect(parsed.from_request, content="None")
  inspect(parsed.web_app_name, content="None")
  inspect(parsed.from_attachment_menu, content="Some(true)")
}

///|
test "WebAppData from fixed JSON" {
  let json = @json.parse(
    #|{"data":"{\"key\":\"value\"}","button_text":"Open WebApp"}
  )
  let parsed : WebAppData = @json.from_json(json)
  inspect(parsed.data, content="{\"key\":\"value\"}")
  inspect(parsed.button_text, content="Open WebApp")
}
