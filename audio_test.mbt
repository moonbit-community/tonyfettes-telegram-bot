///|
test "Audio JSON round-trip" {
  let thumbnail = PhotoSize::new(
    file_id="thumb_id",
    file_unique_id="thumb_unique",
    width=90,
    height=90,
  )
  let audio = Audio::new(
    file_id="CQACAgIAAxkBAAI",
    file_unique_id="AQADAgATaudio",
    duration=180,
    performer="Artist Name",
    title="Song Title",
    file_name="song.mp3",
    mime_type="audio/mpeg",
    file_size=3500000L,
    thumbnail~,
  )
  let json = @json.to_json(audio)
  let parsed : Audio = @json.from_json(json)
  inspect(parsed.file_id, content="CQACAgIAAxkBAAI")
  inspect(parsed.file_unique_id, content="AQADAgATaudio")
  inspect(parsed.duration, content="180")
  inspect(parsed.performer, content="Some(\"Artist Name\")")
  inspect(parsed.title, content="Some(\"Song Title\")")
  inspect(parsed.file_name, content="Some(\"song.mp3\")")
  inspect(parsed.mime_type, content="Some(\"audio/mpeg\")")
  inspect(parsed.file_size, content="Some(3500000)")
}

///|
test "Audio JSON round-trip without optionals" {
  let audio = Audio::new(
    file_id="CQACAgIAAxkBAAI",
    file_unique_id="AQADAgATaudio",
    duration=180,
  )
  let json = @json.to_json(audio)
  let parsed : Audio = @json.from_json(json)
  inspect(parsed.file_id, content="CQACAgIAAxkBAAI")
  inspect(parsed.performer, content="None")
  inspect(parsed.title, content="None")
  inspect(parsed.thumbnail, content="None")
}

///|
test "Audio from fixed JSON" {
  let json = @json.parse(
    (
      #|{"file_id":"CQACAgIAAxkBAAI","file_unique_id":"AQADAgATaudio","duration":180,"performer":"Artist Name","title":"Song Title","file_name":"song.mp3","mime_type":"audio/mpeg","file_size":3500000}
    ),
  )
  let audio : Audio = @json.from_json(json)
  inspect(audio.file_id, content="CQACAgIAAxkBAAI")
  inspect(audio.file_unique_id, content="AQADAgATaudio")
  inspect(audio.duration, content="180")
  inspect(audio.performer, content="Some(\"Artist Name\")")
  inspect(audio.title, content="Some(\"Song Title\")")
  inspect(audio.file_name, content="Some(\"song.mp3\")")
  inspect(audio.mime_type, content="Some(\"audio/mpeg\")")
  inspect(audio.file_size, content="Some(3500000)")
  inspect(audio.thumbnail, content="None")
}

///|
test "Audio from fixed JSON without optionals" {
  let json = @json.parse(
    (
      #|{"file_id":"CQACAgIAAxkBAAI","file_unique_id":"AQADAgATaudio","duration":60}
    ),
  )
  let audio : Audio = @json.from_json(json)
  inspect(audio.file_id, content="CQACAgIAAxkBAAI")
  inspect(audio.duration, content="60")
  inspect(audio.performer, content="None")
  inspect(audio.title, content="None")
  inspect(audio.file_size, content="None")
}
