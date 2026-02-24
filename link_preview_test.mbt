///|
test "LinkPreviewOptions JSON round-trip" {
  let opts = LinkPreviewOptions::new(
    is_disabled=true,
    url="https://example.com",
    prefer_small_media=false,
    prefer_large_media=true,
    show_above_text=true,
  )
  let json = @json.to_json(opts)
  let parsed : LinkPreviewOptions = @json.from_json(json)
  inspect(parsed.is_disabled, content="Some(true)")
  inspect(parsed.url, content="Some(\"https://example.com\")")
  inspect(parsed.prefer_small_media, content="Some(false)")
  inspect(parsed.prefer_large_media, content="Some(true)")
  inspect(parsed.show_above_text, content="Some(true)")
}

///|
test "LinkPreviewOptions JSON round-trip empty" {
  let opts = LinkPreviewOptions::new()
  let json = @json.to_json(opts)
  let parsed : LinkPreviewOptions = @json.from_json(json)
  inspect(parsed.is_disabled, content="None")
  inspect(parsed.url, content="None")
  inspect(parsed.prefer_small_media, content="None")
  inspect(parsed.prefer_large_media, content="None")
  inspect(parsed.show_above_text, content="None")
}

///|
test "TextQuote JSON round-trip" {
  let quote = TextQuote::new(
    text="Hello, world!",
    entities=[
      MessageEntity::new(type_="bold", offset=0, length=5),
      MessageEntity::new(type_="italic", offset=7, length=6),
    ],
    position=10,
    is_manual=true,
  )
  let json = @json.to_json(quote)
  let parsed : TextQuote = @json.from_json(json)
  inspect(parsed.text, content="Hello, world!")
  inspect(parsed.position, content="10")
  inspect(parsed.is_manual, content="Some(true)")
  guard parsed.entities is Some(entities) else {
    fail("Expected entities to be Some")
  }
  inspect(entities.length(), content="2")
  inspect(entities[0].type_, content="bold")
  inspect(entities[1].type_, content="italic")
}

///|
test "TextQuote JSON round-trip minimal" {
  let quote = TextQuote::new(text="Simple quote", position=5)
  let json = @json.to_json(quote)
  let parsed : TextQuote = @json.from_json(json)
  inspect(parsed.text, content="Simple quote")
  inspect(parsed.position, content="5")
  inspect(parsed.entities, content="None")
  inspect(parsed.is_manual, content="None")
}
