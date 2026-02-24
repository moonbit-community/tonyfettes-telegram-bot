///|
test "PhotoSize JSON round-trip" {
  let photo = PhotoSize::new(
    file_id="AgACAgIAAxkBAAI",
    file_unique_id="AQADAgAT",
    width=320,
    height=240,
    file_size=12345L,
  )
  let json = @json.to_json(photo)
  let parsed : PhotoSize = @json.from_json(json)
  inspect(parsed.file_id, content="AgACAgIAAxkBAAI")
  inspect(parsed.file_unique_id, content="AQADAgAT")
  inspect(parsed.width, content="320")
  inspect(parsed.height, content="240")
  inspect(parsed.file_size, content="Some(12345)")
}

///|
test "PhotoSize JSON round-trip without optional" {
  let photo = PhotoSize::new(
    file_id="AgACAgIAAxkBAAI",
    file_unique_id="AQADAgAT",
    width=640,
    height=480,
  )
  let json = @json.to_json(photo)
  let parsed : PhotoSize = @json.from_json(json)
  inspect(parsed.file_id, content="AgACAgIAAxkBAAI")
  inspect(parsed.file_size, content="None")
}

///|
test "PhotoSize from fixed JSON" {
  let json = @json.parse(
    (
      #|{"file_id":"AgACAgIAAxkBAAI","file_unique_id":"AQADAgAT","width":320,"height":240,"file_size":12345}
    ),
  )
  let photo : PhotoSize = @json.from_json(json)
  inspect(photo.file_id, content="AgACAgIAAxkBAAI")
  inspect(photo.file_unique_id, content="AQADAgAT")
  inspect(photo.width, content="320")
  inspect(photo.height, content="240")
  inspect(photo.file_size, content="Some(12345)")
}

///|
test "PhotoSize from fixed JSON without optional" {
  let json = @json.parse(
    (
      #|{"file_id":"AgACAgIAAxkBAAI","file_unique_id":"AQADAgAT","width":640,"height":480}
    ),
  )
  let photo : PhotoSize = @json.from_json(json)
  inspect(photo.file_id, content="AgACAgIAAxkBAAI")
  inspect(photo.width, content="640")
  inspect(photo.height, content="480")
  inspect(photo.file_size, content="None")
}
