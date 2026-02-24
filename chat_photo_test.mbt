///|
test "ChatPhoto JSON round-trip" {
  let object = ChatPhoto::new(
    small_file_id="small123",
    small_file_unique_id="smalluniq123",
    big_file_id="big123",
    big_file_unique_id="biguniq123",
  )
  let json = object.to_json()
  let parsed : ChatPhoto = @json.from_json(json)
  inspect(parsed.small_file_id, content="small123")
  inspect(parsed.big_file_id, content="big123")
}

///|
test "ChatPhoto from fixed JSON" {
  let json = @json.parse(
    (
      #|{"small_file_id":"AgACAgIAAxk","small_file_unique_id":"AQADAgATref","big_file_id":"AgACAgIAAxkBAAIBs","big_file_unique_id":"AQADAgATref2"}
    ),
  )
  let photo : ChatPhoto = @json.from_json(json)
  inspect(photo.small_file_id, content="AgACAgIAAxk")
  inspect(photo.small_file_unique_id, content="AQADAgATref")
  inspect(photo.big_file_id, content="AgACAgIAAxkBAAIBs")
  inspect(photo.big_file_unique_id, content="AQADAgATref2")
}
