///|
test "LinkPreviewOptions JSON round-trip" {
  let options = LinkPreviewOptions::new(
    is_disabled=true,
    url="https://example.com",
    prefer_small_media=false,
    prefer_large_media=true,
    show_above_text=false,
  )
  let json = @json.to_json(options)
  let parsed : LinkPreviewOptions = @json.from_json(json)
  inspect(parsed.is_disabled, content="Some(true)")
  inspect(parsed.url, content="Some(\"https://example.com\")")
  inspect(parsed.prefer_small_media, content="Some(false)")
  inspect(parsed.prefer_large_media, content="Some(true)")
  inspect(parsed.show_above_text, content="Some(false)")
}

///|
test "LinkPreviewOptions JSON minimal" {
  let options = LinkPreviewOptions::new()
  let json = @json.to_json(options)
  let parsed : LinkPreviewOptions = @json.from_json(json)
  inspect(parsed.is_disabled, content="None")
  inspect(parsed.url, content="None")
}

///|
test "InputTextMessageContent JSON round-trip" {
  let content = InputTextMessageContent::new(
    message_text="Hello, World!",
    parse_mode="HTML",
    link_preview_options=LinkPreviewOptions::new(is_disabled=true),
  )
  let json = @json.to_json(content)
  let parsed : InputTextMessageContent = @json.from_json(json)
  inspect(parsed.message_text, content="Hello, World!")
  inspect(parsed.parse_mode, content="Some(\"HTML\")")
  inspect(parsed.entities, content="None")
  inspect(
    parsed.link_preview_options,
    content="Some({is_disabled: Some(true), url: None, prefer_small_media: None, prefer_large_media: None, show_above_text: None})",
  )
}

///|
test "InputTextMessageContent JSON minimal" {
  let content = InputTextMessageContent::new(message_text="Simple message")
  let json = @json.to_json(content)
  let parsed : InputTextMessageContent = @json.from_json(json)
  inspect(parsed.message_text, content="Simple message")
  inspect(parsed.parse_mode, content="None")
}

///|
test "InlineQueryResultArticle JSON round-trip" {
  let article = InlineQueryResultArticle::new(
    id="article_1",
    title="Test Article",
    input_message_content=InputTextMessageContent::new(
      message_text="Article content",
    ),
    url="https://example.com/article",
    hide_url=true,
    description="A test article",
    thumbnail_url="https://example.com/thumb.jpg",
    thumbnail_width=100,
    thumbnail_height=100,
  )
  let json = @json.to_json(article)
  let parsed : InlineQueryResultArticle = @json.from_json(json)
  inspect(parsed.type_, content="article")
  inspect(parsed.id, content="article_1")
  inspect(parsed.title, content="Test Article")
  inspect(parsed.input_message_content.message_text, content="Article content")
  inspect(parsed.url, content="Some(\"https://example.com/article\")")
  inspect(parsed.hide_url, content="Some(true)")
  inspect(parsed.description, content="Some(\"A test article\")")
  inspect(
    parsed.thumbnail_url,
    content="Some(\"https://example.com/thumb.jpg\")",
  )
  inspect(parsed.thumbnail_width, content="Some(100)")
  inspect(parsed.thumbnail_height, content="Some(100)")
}

///|
test "InlineQueryResultArticle JSON minimal" {
  let article = InlineQueryResultArticle::new(
    id="article_2",
    title="Minimal Article",
    input_message_content=InputTextMessageContent::new(message_text="Content"),
  )
  let json = @json.to_json(article)
  let parsed : InlineQueryResultArticle = @json.from_json(json)
  inspect(parsed.type_, content="article")
  inspect(parsed.id, content="article_2")
  inspect(parsed.title, content="Minimal Article")
  inspect(parsed.url, content="None")
  inspect(parsed.reply_markup, content="None")
}

///|
test "InlineQueryResultArticle with reply_markup" {
  let article = InlineQueryResultArticle::new(
    id="article_3",
    title="Article with Button",
    input_message_content=InputTextMessageContent::new(
      message_text="Click below",
    ),
    reply_markup=InlineKeyboardMarkup::new(inline_keyboard=[
      [InlineKeyboardButton::new(text="Click", url="https://example.com")],
    ]),
  )
  let json = @json.to_json(article)
  let parsed : InlineQueryResultArticle = @json.from_json(json)
  guard parsed.reply_markup is Some(markup) else {
    fail("Expected reply_markup")
  }
  inspect(markup.inline_keyboard.length(), content="1")
  inspect(markup.inline_keyboard[0][0].text, content="Click")
}

///|
test "InlineQueryResultContact JSON round-trip" {
  let contact = InlineQueryResultContact::new(
    id="contact_1",
    phone_number="+1234567890",
    first_name="John",
    last_name="Doe",
    vcard="BEGIN:VCARD\\nVERSION:3.0\\nFN:John Doe\\nEND:VCARD",
    thumbnail_url="https://example.com/photo.jpg",
    thumbnail_width=50,
    thumbnail_height=50,
  )
  let json = @json.to_json(contact)
  let parsed : InlineQueryResultContact = @json.from_json(json)
  inspect(parsed.type_, content="contact")
  inspect(parsed.id, content="contact_1")
  inspect(parsed.phone_number, content="+1234567890")
  inspect(parsed.first_name, content="John")
  inspect(parsed.last_name, content="Some(\"Doe\")")
  inspect(
    parsed.vcard,
    content="Some(\"BEGIN:VCARD\\\\nVERSION:3.0\\\\nFN:John Doe\\\\nEND:VCARD\")",
  )
  inspect(
    parsed.thumbnail_url,
    content="Some(\"https://example.com/photo.jpg\")",
  )
}

///|
test "InlineQueryResultContact JSON minimal" {
  let contact = InlineQueryResultContact::new(
    id="contact_2",
    phone_number="+9876543210",
    first_name="Jane",
  )
  let json = @json.to_json(contact)
  let parsed : InlineQueryResultContact = @json.from_json(json)
  inspect(parsed.type_, content="contact")
  inspect(parsed.id, content="contact_2")
  inspect(parsed.phone_number, content="+9876543210")
  inspect(parsed.first_name, content="Jane")
  inspect(parsed.last_name, content="None")
  inspect(parsed.vcard, content="None")
  inspect(parsed.input_message_content, content="None")
}

///|
test "InlineQueryResultLocation JSON round-trip" {
  let location = InlineQueryResultLocation::new(
    id="location_1",
    latitude=40.7484,
    longitude=-73.9857,
    title="Empire State Building",
    horizontal_accuracy=10.5,
    live_period=3600,
    heading=90,
    proximity_alert_radius=500,
    thumbnail_url="https://example.com/map.jpg",
    thumbnail_width=200,
    thumbnail_height=200,
  )
  let json = @json.to_json(location)
  let parsed : InlineQueryResultLocation = @json.from_json(json)
  inspect(parsed.type_, content="location")
  inspect(parsed.id, content="location_1")
  inspect(parsed.latitude, content="40.7484")
  inspect(parsed.longitude, content="-73.9857")
  inspect(parsed.title, content="Empire State Building")
  inspect(parsed.horizontal_accuracy, content="Some(10.5)")
  inspect(parsed.live_period, content="Some(3600)")
  inspect(parsed.heading, content="Some(90)")
  inspect(parsed.proximity_alert_radius, content="Some(500)")
  inspect(parsed.thumbnail_url, content="Some(\"https://example.com/map.jpg\")")
}

///|
test "InlineQueryResultLocation JSON minimal" {
  let location = InlineQueryResultLocation::new(
    id="location_2",
    latitude=48.8584,
    longitude=2.2945,
    title="Eiffel Tower",
  )
  let json = @json.to_json(location)
  let parsed : InlineQueryResultLocation = @json.from_json(json)
  inspect(parsed.type_, content="location")
  inspect(parsed.id, content="location_2")
  inspect(parsed.latitude, content="48.8584")
  inspect(parsed.longitude, content="2.2945")
  inspect(parsed.title, content="Eiffel Tower")
  inspect(parsed.horizontal_accuracy, content="None")
  inspect(parsed.live_period, content="None")
}

///|
test "InlineQueryResultVenue JSON round-trip" {
  let venue = InlineQueryResultVenue::new(
    id="venue_1",
    latitude=40.7484,
    longitude=-73.9857,
    title="Empire State Building",
    address="350 Fifth Avenue, New York, NY",
    foursquare_id="4b5a0c13f964a520e5cf28e3",
    foursquare_type="building",
    google_place_id="ChIJaXQRs6lZwokRY6EFpJnhNNE",
    google_place_type="point_of_interest",
    thumbnail_url="https://example.com/venue.jpg",
    thumbnail_width=150,
    thumbnail_height=150,
  )
  let json = @json.to_json(venue)
  let parsed : InlineQueryResultVenue = @json.from_json(json)
  inspect(parsed.type_, content="venue")
  inspect(parsed.id, content="venue_1")
  inspect(parsed.latitude, content="40.7484")
  inspect(parsed.longitude, content="-73.9857")
  inspect(parsed.title, content="Empire State Building")
  inspect(parsed.address, content="350 Fifth Avenue, New York, NY")
  inspect(parsed.foursquare_id, content="Some(\"4b5a0c13f964a520e5cf28e3\")")
  inspect(parsed.foursquare_type, content="Some(\"building\")")
  inspect(
    parsed.google_place_id,
    content="Some(\"ChIJaXQRs6lZwokRY6EFpJnhNNE\")",
  )
  inspect(parsed.google_place_type, content="Some(\"point_of_interest\")")
  inspect(
    parsed.thumbnail_url,
    content="Some(\"https://example.com/venue.jpg\")",
  )
}

///|
test "InlineQueryResultVenue JSON minimal" {
  let venue = InlineQueryResultVenue::new(
    id="venue_2",
    latitude=48.8584,
    longitude=2.2945,
    title="Eiffel Tower",
    address="Champ de Mars, Paris",
  )
  let json = @json.to_json(venue)
  let parsed : InlineQueryResultVenue = @json.from_json(json)
  inspect(parsed.type_, content="venue")
  inspect(parsed.id, content="venue_2")
  inspect(parsed.title, content="Eiffel Tower")
  inspect(parsed.address, content="Champ de Mars, Paris")
  inspect(parsed.foursquare_id, content="None")
  inspect(parsed.google_place_id, content="None")
  inspect(parsed.reply_markup, content="None")
}

///|
test "InlineQueryResultVenue with reply_markup and input_message_content" {
  let venue = InlineQueryResultVenue::new(
    id="venue_3",
    latitude=51.5074,
    longitude=-0.1278,
    title="Big Ben",
    address="Westminster, London",
    reply_markup=InlineKeyboardMarkup::new(inline_keyboard=[
      [InlineKeyboardButton::new(text="View", callback_data="view_venue")],
    ]),
    input_message_content=InputTextMessageContent::new(
      message_text="Check out Big Ben!",
      parse_mode="HTML",
    ),
  )
  let json = @json.to_json(venue)
  let parsed : InlineQueryResultVenue = @json.from_json(json)
  inspect(parsed.title, content="Big Ben")
  guard parsed.reply_markup is Some(markup) else {
    fail("Expected reply_markup")
  }
  inspect(markup.inline_keyboard[0][0].text, content="View")
  guard parsed.input_message_content is Some(content) else {
    fail("Expected input_message_content")
  }
  inspect(content.message_text, content="Check out Big Ben!")
  inspect(content.parse_mode, content="Some(\"HTML\")")
}
