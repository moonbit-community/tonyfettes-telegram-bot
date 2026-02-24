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

///|
test "LinkPreviewOptions from fixed JSON with all fields" {
  let json = @json.parse(
    #|{"is_disabled":true,"url":"https://example.com","prefer_small_media":false,"prefer_large_media":true,"show_above_text":true}
  )
  let opts : LinkPreviewOptions = @json.from_json(json)
  inspect(opts.is_disabled, content="Some(true)")
  inspect(opts.url, content="Some(\"https://example.com\")")
  inspect(opts.prefer_small_media, content="Some(false)")
  inspect(opts.prefer_large_media, content="Some(true)")
  inspect(opts.show_above_text, content="Some(true)")
}

///|
test "LinkPreviewOptions from fixed JSON empty" {
  let json = @json.parse(
    #|{}
  )
  let opts : LinkPreviewOptions = @json.from_json(json)
  inspect(opts.is_disabled, content="None")
  inspect(opts.url, content="None")
  inspect(opts.prefer_small_media, content="None")
  inspect(opts.prefer_large_media, content="None")
  inspect(opts.show_above_text, content="None")
}

///|
test "TextQuote from fixed JSON with entities and is_manual" {
  let json = @json.parse(
    #|{"text":"Hello, world!","entities":[{"type":"bold","offset":0,"length":5},{"type":"italic","offset":7,"length":5}],"position":10,"is_manual":true}
  )
  let quote : TextQuote = @json.from_json(json)
  inspect(quote.text, content="Hello, world!")
  inspect(quote.position, content="10")
  inspect(quote.is_manual, content="Some(true)")
  guard quote.entities is Some(entities) else {
    fail("Expected entities to be Some")
  }
  inspect(entities.length(), content="2")
  inspect(entities[0].type_, content="bold")
  inspect(entities[1].type_, content="italic")
}

///|
test "TextQuote from fixed JSON minimal" {
  let json = @json.parse(
    #|{"text":"Simple quote","position":5}
  )
  let quote : TextQuote = @json.from_json(json)
  inspect(quote.text, content="Simple quote")
  inspect(quote.position, content="5")
  inspect(quote.entities, content="None")
  inspect(quote.is_manual, content="None")
}
