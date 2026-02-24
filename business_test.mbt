///|
test "BusinessOpeningHoursInterval JSON round-trip" {
  let interval = BusinessOpeningHoursInterval::new(
    opening_minute=540,
    closing_minute=1020,
  )
  let json = interval.to_json()
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
  let json = hours.to_json()
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
  let json = location.to_json()
  let parsed : BusinessLocation = @json.from_json(json)
  inspect(parsed.address, content="123 Main Street, Berlin")
  inspect(parsed.location.map(fn(l) { l.latitude }), content="Some(52.52)")
}

///|
test "BusinessLocation JSON round-trip without location" {
  let location = BusinessLocation::new(address="123 Main Street, Berlin")
  let json = location.to_json()
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
  let json = intro.to_json()
  let parsed : BusinessIntro = @json.from_json(json)
  inspect(parsed.title, content="Some(\"Welcome\")")
  inspect(parsed.message, content="Some(\"Hello, how can I help you?\")")
  inspect(parsed.sticker, content="None")
}

///|
test "BusinessIntro JSON round-trip empty" {
  let intro = BusinessIntro::new()
  let json = intro.to_json()
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
  let json = connection.to_json()
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
  let json = deleted.to_json()
  let parsed : BusinessMessagesDeleted = @json.from_json(json)
  inspect(parsed.business_connection_id, content="conn_12345")
  inspect(parsed.chat.id, content="789")
  inspect(parsed.message_ids, content="[1, 2, 3, 4, 5]")
}

///|
test "BusinessOpeningHoursInterval from fixed JSON" {
  let json = @json.parse(
    (
      #|{"opening_minute":540,"closing_minute":1020}
    ),
  )
  let interval : BusinessOpeningHoursInterval = @json.from_json(json)
  inspect(interval.opening_minute, content="540")
  inspect(interval.closing_minute, content="1020")
}

///|
test "BusinessOpeningHours from fixed JSON" {
  let json = @json.parse(
    (
      #|{"time_zone_name":"America/New_York","opening_hours":[{"opening_minute":480,"closing_minute":1080},{"opening_minute":1920,"closing_minute":2520}]}
    ),
  )
  let hours : BusinessOpeningHours = @json.from_json(json)
  inspect(hours.time_zone_name, content="America/New_York")
  inspect(hours.opening_hours.length(), content="2")
  inspect(hours.opening_hours[0].opening_minute, content="480")
  inspect(hours.opening_hours[1].closing_minute, content="2520")
}

///|
test "BusinessLocation from fixed JSON with location" {
  let json = @json.parse(
    (
      #|{"address":"10 Downing Street, London","location":{"latitude":51.5034,"longitude":-0.1276}}
    ),
  )
  let loc : BusinessLocation = @json.from_json(json)
  inspect(loc.address, content="10 Downing Street, London")
  inspect(loc.location is Some(_), content="true")
  guard loc.location is Some(l) else { fail("Expected location") }
  inspect(l.latitude, content="51.5034")
}

///|
test "BusinessLocation from fixed JSON without location" {
  let json = @json.parse(
    (
      #|{"address":"Remote Business"}
    ),
  )
  let loc : BusinessLocation = @json.from_json(json)
  inspect(loc.address, content="Remote Business")
  inspect(loc.location, content="None")
}

///|
test "BusinessIntro from fixed JSON with fields" {
  let json = @json.parse(
    (
      #|{"title":"Welcome to our shop","message":"We are open 9-5"}
    ),
  )
  let intro : BusinessIntro = @json.from_json(json)
  inspect(intro.title, content="Some(\"Welcome to our shop\")")
  inspect(intro.message, content="Some(\"We are open 9-5\")")
  inspect(intro.sticker, content="None")
}

///|
test "BusinessIntro from fixed JSON empty" {
  let json = @json.parse(
    (
      #|{}
    ),
  )
  let intro : BusinessIntro = @json.from_json(json)
  inspect(intro.title, content="None")
  inspect(intro.message, content="None")
  inspect(intro.sticker, content="None")
}

///|
test "BusinessConnection from fixed JSON" {
  let json = @json.parse(
    (
      #|{"id":"bc_abc123","user":{"id":987654321,"is_bot":false,"first_name":"Alice"},"user_chat_id":123456789,"date":1700000000,"can_reply":true,"is_enabled":true}
    ),
  )
  let conn : BusinessConnection = @json.from_json(json)
  inspect(conn.id, content="bc_abc123")
  inspect(conn.user.first_name, content="Alice")
  inspect(conn.user.id, content="987654321")
  inspect(conn.user_chat_id, content="123456789")
  inspect(conn.date, content="1700000000")
  inspect(conn.can_reply, content="true")
  inspect(conn.is_enabled, content="true")
}

///|
test "BusinessConnection from fixed JSON disabled" {
  let json = @json.parse(
    (
      #|{"id":"bc_xyz999","user":{"id":111222333,"is_bot":false,"first_name":"Bob"},"user_chat_id":444555666,"date":1710000000,"can_reply":false,"is_enabled":false}
    ),
  )
  let conn : BusinessConnection = @json.from_json(json)
  inspect(conn.id, content="bc_xyz999")
  inspect(conn.user_chat_id, content="444555666")
  inspect(conn.can_reply, content="false")
  inspect(conn.is_enabled, content="false")
}

///|
test "BusinessMessagesDeleted from fixed JSON" {
  let json = @json.parse(
    (
      #|{"business_connection_id":"bc_del001","chat":{"id":100200300,"type":"group","title":"My Group"},"message_ids":[10,20,30]}
    ),
  )
  let deleted : BusinessMessagesDeleted = @json.from_json(json)
  inspect(deleted.business_connection_id, content="bc_del001")
  inspect(deleted.chat.id, content="100200300")
  inspect(deleted.message_ids, content="[10, 20, 30]")
}
