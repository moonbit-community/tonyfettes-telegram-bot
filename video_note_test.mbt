///|
test "VideoNote JSON round-trip" {
  let thumbnail = PhotoSize::new(
    file_id="thumb_id",
    file_unique_id="thumb_unique",
    width=90,
    height=90,
  )
  let video_note = VideoNote::new(
    file_id="DQACAgIAAxkBAAI",
    file_unique_id="AQADAgATvnote",
    length=240,
    duration=30,
    thumbnail~,
    file_size=500000L,
  )
  let json = @json.to_json(video_note)
  let parsed : VideoNote = @json.from_json(json)
  inspect(parsed.file_id, content="DQACAgIAAxkBAAI")
  inspect(parsed.file_unique_id, content="AQADAgATvnote")
  inspect(parsed.length, content="240")
  inspect(parsed.duration, content="30")
  inspect(parsed.file_size, content="Some(500000)")
}

///|
test "VideoNote JSON round-trip without optionals" {
  let video_note = VideoNote::new(
    file_id="DQACAgIAAxkBAAI",
    file_unique_id="AQADAgATvnote",
    length=240,
    duration=30,
  )
  let json = @json.to_json(video_note)
  let parsed : VideoNote = @json.from_json(json)
  inspect(parsed.file_id, content="DQACAgIAAxkBAAI")
  inspect(parsed.thumbnail, content="None")
  inspect(parsed.file_size, content="None")
}

///|
test "VideoNote from fixed JSON" {
  let json = @json.parse(
    (
      #|{"file_id":"DQACAgIAAxkBAAI","file_unique_id":"AQADAgATvnote","length":240,"duration":30,"thumbnail":{"file_id":"thumb_id","file_unique_id":"thumb_unique","width":90,"height":90},"file_size":500000}
    ),
  )
  let video_note : VideoNote = @json.from_json(json)
  inspect(video_note.file_id, content="DQACAgIAAxkBAAI")
  inspect(video_note.file_unique_id, content="AQADAgATvnote")
  inspect(video_note.length, content="240")
  inspect(video_note.duration, content="30")
  inspect(video_note.file_size, content="Some(500000)")
}

///|
test "VideoNote from fixed JSON without optionals" {
  let json = @json.parse(
    (
      #|{"file_id":"DQACAgIAAxkBAAI","file_unique_id":"AQADAgATvnote","length":240,"duration":30}
    ),
  )
  let video_note : VideoNote = @json.from_json(json)
  inspect(video_note.file_id, content="DQACAgIAAxkBAAI")
  inspect(video_note.length, content="240")
  inspect(video_note.duration, content="30")
  inspect(video_note.thumbnail, content="None")
  inspect(video_note.file_size, content="None")
}
