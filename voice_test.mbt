///|
test "Voice JSON round-trip" {
  let voice = Voice::new(
    file_id="AwACAgIAAxkBAAI",
    file_unique_id="AQADAgATvoice",
    duration=15,
    mime_type="audio/ogg",
    file_size=25000L,
  )
  let json = @json.to_json(voice)
  let parsed : Voice = @json.from_json(json)
  inspect(parsed.file_id, content="AwACAgIAAxkBAAI")
  inspect(parsed.file_unique_id, content="AQADAgATvoice")
  inspect(parsed.duration, content="15")
  inspect(parsed.mime_type, content="Some(\"audio/ogg\")")
  inspect(parsed.file_size, content="Some(25000)")
}

///|
test "Voice JSON round-trip without optionals" {
  let voice = Voice::new(
    file_id="AwACAgIAAxkBAAI",
    file_unique_id="AQADAgATvoice",
    duration=15,
  )
  let json = @json.to_json(voice)
  let parsed : Voice = @json.from_json(json)
  inspect(parsed.file_id, content="AwACAgIAAxkBAAI")
  inspect(parsed.mime_type, content="None")
  inspect(parsed.file_size, content="None")
}

///|
test "Voice from fixed JSON" {
  let json = @json.parse(
    #|{"file_id":"AwACAgIAAxkBAAI","file_unique_id":"AQADAgATvoice","duration":15,"mime_type":"audio/ogg","file_size":25000}
  )
  let voice : Voice = @json.from_json(json)
  inspect(voice.file_id, content="AwACAgIAAxkBAAI")
  inspect(voice.file_unique_id, content="AQADAgATvoice")
  inspect(voice.duration, content="15")
  inspect(voice.mime_type, content="Some(\"audio/ogg\")")
  inspect(voice.file_size, content="Some(25000)")
}

///|
test "Voice from fixed JSON without optionals" {
  let json = @json.parse(
    #|{"file_id":"AwACAgIAAxkBAAI","file_unique_id":"AQADAgATvoice","duration":30}
  )
  let voice : Voice = @json.from_json(json)
  inspect(voice.file_id, content="AwACAgIAAxkBAAI")
  inspect(voice.duration, content="30")
  inspect(voice.mime_type, content="None")
  inspect(voice.file_size, content="None")
}
