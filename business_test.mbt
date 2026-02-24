///|
test "BusinessOpeningHoursInterval JSON round-trip" {
  let interval = BusinessOpeningHoursInterval::new(
    opening_minute=540,
    closing_minute=1020,
  )
  let json = @json.to_json(interval)
  let parsed : BusinessOpeningHoursInterval = @json.from_json(json)
  inspect(parsed.opening_minute, content="540")
  inspect(parsed.closing_minute, content="1020")
}

///|
test "BusinessOpeningHours JSON round-trip" {
  let hours = BusinessOpeningHours::new(time_zone_name="Europe/Berlin", opening_hours=[
    BusinessOpeningHoursInterval::new(opening_minute=540, closing_minute=1020),
    BusinessOpeningHoursInterval::new(opening_minute=1980, closing_minute=2460),
  ])
  let json = @json.to_json(hours)
  let parsed : BusinessOpeningHours = @json.from_json(json)
  inspect(parsed.time_zone_name, content="Europe/Berlin")
  inspect(parsed.opening_hours.length(), content="2")
  inspect(parsed.opening_hours[0].opening_minute, content="540")
  inspect(parsed.opening_hours[1].closing_minute, content="2460")
}

///|
test "BusinessLocation JSON round-trip" {
  let location = BusinessLocation::new(
    address="123 Main Street, Berlin",
    location=Location::new(latitude=52.52, longitude=13.405),
  )
  let json = @json.to_json(location)
  let parsed : BusinessLocation = @json.from_json(json)
  inspect(parsed.address, content="123 Main Street, Berlin")
  inspect(parsed.location.map(fn(l) { l.latitude }), content="Some(52.52)")
}

///|
test "BusinessLocation JSON round-trip without location" {
  let location = BusinessLocation::new(address="123 Main Street, Berlin")
  let json = @json.to_json(location)
  let parsed : BusinessLocation = @json.from_json(json)
  inspect(parsed.address, content="123 Main Street, Berlin")
  inspect(parsed.location, content="None")
}

///|
test "BusinessIntro JSON round-trip" {
  let intro = BusinessIntro::new(
    title="Welcome",
    message="Hello, how can I help you?",
  )
  let json = @json.to_json(intro)
  let parsed : BusinessIntro = @json.from_json(json)
  inspect(parsed.title, content="Some(\"Welcome\")")
  inspect(parsed.message, content="Some(\"Hello, how can I help you?\")")
  inspect(parsed.sticker, content="None")
}

///|
test "BusinessIntro JSON round-trip empty" {
  let intro = BusinessIntro::new()
  let json = @json.to_json(intro)
  let parsed : BusinessIntro = @json.from_json(json)
  inspect(parsed.title, content="None")
  inspect(parsed.message, content="None")
  inspect(parsed.sticker, content="None")
}

///|
test "BusinessConnection JSON round-trip" {
  let connection = BusinessConnection::new(
    id="conn_12345",
    user=User::new(id=123L, is_bot=false, first_name="John"),
    user_chat_id=456L,
    date=1700000000,
    can_reply=true,
    is_enabled=true,
  )
  let json = @json.to_json(connection)
  let parsed : BusinessConnection = @json.from_json(json)
  inspect(parsed.id, content="conn_12345")
  inspect(parsed.user.first_name, content="John")
  inspect(parsed.user_chat_id, content="456")
  inspect(parsed.date, content="1700000000")
  inspect(parsed.can_reply, content="true")
  inspect(parsed.is_enabled, content="true")
}

///|
test "BusinessMessagesDeleted JSON round-trip" {
  let deleted = BusinessMessagesDeleted::new(
    business_connection_id="conn_12345",
    chat=Chat::new(id=789L, type_=ChatType::Private),
    message_ids=[1, 2, 3, 4, 5],
  )
  let json = @json.to_json(deleted)
  let parsed : BusinessMessagesDeleted = @json.from_json(json)
  inspect(parsed.business_connection_id, content="conn_12345")
  inspect(parsed.chat.id, content="789")
  inspect(parsed.message_ids, content="[1, 2, 3, 4, 5]")
}
