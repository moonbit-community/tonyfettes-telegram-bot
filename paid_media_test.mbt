///|
test "PaidMediaPreview JSON round-trip" {
  let preview = PaidMediaPreview::new(width=640, height=480, duration=30)
  let media : PaidMedia = Preview(preview)
  let json = @json.to_json(media)
  let parsed : PaidMedia = @json.from_json(json)
  guard parsed is Preview(p) else { fail("Expected Preview variant") }
  inspect(p.width, content="Some(640)")
  inspect(p.height, content="Some(480)")
  inspect(p.duration, content="Some(30)")
}

///|
test "PaidMediaPreview empty JSON round-trip" {
  let preview = PaidMediaPreview::new()
  let media : PaidMedia = Preview(preview)
  let json = @json.to_json(media)
  let parsed : PaidMedia = @json.from_json(json)
  guard parsed is Preview(p) else { fail("Expected Preview variant") }
  inspect(p.width, content="None")
  inspect(p.height, content="None")
  inspect(p.duration, content="None")
}

///|
test "PaidMediaPhoto JSON round-trip" {
  let photo_size = PhotoSize::new(
    file_id="photo123",
    file_unique_id="unique123",
    width=800,
    height=600,
  )
  let photo = PaidMediaPhoto::new(photo=[photo_size])
  let media : PaidMedia = Photo(photo)
  let json = @json.to_json(media)
  let parsed : PaidMedia = @json.from_json(json)
  guard parsed is Photo(p) else { fail("Expected Photo variant") }
  inspect(p.photo.length(), content="1")
  inspect(p.photo[0].file_id, content="photo123")
  inspect(p.photo[0].width, content="800")
}

///|
test "PaidMediaVideo JSON round-trip" {
  let video = Video::new(
    file_id="video456",
    file_unique_id="unique456",
    width=1920,
    height=1080,
    duration=120,
  )
  let video_media = PaidMediaVideo::new(video~)
  let media : PaidMedia = Video(video_media)
  let json = @json.to_json(media)
  let parsed : PaidMedia = @json.from_json(json)
  guard parsed is Video(v) else { fail("Expected Video variant") }
  inspect(v.video.file_id, content="video456")
  inspect(v.video.width, content="1920")
  inspect(v.video.height, content="1080")
  inspect(v.video.duration, content="120")
}

///|
test "PaidMediaInfo JSON round-trip" {
  let preview = PaidMediaPreview::new(width=320, height=240)
  let video = Video::new(
    file_id="vid789",
    file_unique_id="uniq789",
    width=1280,
    height=720,
    duration=60,
  )
  let info = PaidMediaInfo::new(star_count=100, paid_media=[
    Preview(preview),
    Video(PaidMediaVideo::new(video~)),
  ])
  let json = @json.to_json(info)
  let parsed : PaidMediaInfo = @json.from_json(json)
  inspect(parsed.star_count, content="100")
  inspect(parsed.paid_media.length(), content="2")
  guard parsed.paid_media[0] is Preview(p) else {
    fail("Expected Preview as first element")
  }
  inspect(p.width, content="Some(320)")
  guard parsed.paid_media[1] is Video(v) else {
    fail("Expected Video as second element")
  }
  inspect(v.video.duration, content="60")
}

///|
test "PhotoSize JSON round-trip" {
  let photo = PhotoSize::new(
    file_id="file123",
    file_unique_id="unique123",
    width=100,
    height=200,
  )
  let json = @json.to_json(photo)
  let parsed : PhotoSize = @json.from_json(json)
  inspect(parsed.file_id, content="file123")
  inspect(parsed.file_unique_id, content="unique123")
  inspect(parsed.width, content="100")
  inspect(parsed.height, content="200")
}

///|
test "Video JSON round-trip" {
  let video = Video::new(
    file_id="vidfile",
    file_unique_id="vidunique",
    width=1920,
    height=1080,
    duration=300,
  )
  let json = @json.to_json(video)
  let parsed : Video = @json.from_json(json)
  inspect(parsed.file_id, content="vidfile")
  inspect(parsed.file_unique_id, content="vidunique")
  inspect(parsed.width, content="1920")
  inspect(parsed.height, content="1080")
  inspect(parsed.duration, content="300")
}

///|
test "PaidMedia::Preview from fixed JSON with all optional fields" {
  let json = @json.parse(
    #|{"type":"preview","width":640,"height":480,"duration":15}
  )
  let media : PaidMedia = @json.from_json(json)
  guard media is Preview(p) else { fail("Expected Preview") }
  inspect(p.width, content="Some(640)")
  inspect(p.height, content="Some(480)")
  inspect(p.duration, content="Some(15)")
}

///|
test "PaidMedia::Preview from fixed JSON with no optional fields" {
  let json = @json.parse(
    #|{"type":"preview"}
  )
  let media : PaidMedia = @json.from_json(json)
  guard media is Preview(p) else { fail("Expected Preview") }
  inspect(p.width, content="None")
  inspect(p.height, content="None")
  inspect(p.duration, content="None")
}

///|
test "PaidMedia::Photo from fixed JSON" {
  let json = @json.parse(
    #|{"type":"photo","photo":[{"file_id":"photo_id","file_unique_id":"photo_unique","width":800,"height":600}]}
  )
  let media : PaidMedia = @json.from_json(json)
  guard media is Photo(p) else { fail("Expected Photo") }
  inspect(p.photo.length(), content="1")
  inspect(p.photo[0].file_id, content="photo_id")
  inspect(p.photo[0].width, content="800")
  inspect(p.photo[0].height, content="600")
}

///|
test "PaidMedia::Video from fixed JSON" {
  let json = @json.parse(
    #|{"type":"video","video":{"file_id":"vid_id","file_unique_id":"vid_unique","width":1280,"height":720,"duration":60}}
  )
  let media : PaidMedia = @json.from_json(json)
  guard media is Video(v) else { fail("Expected Video") }
  inspect(v.video.file_id, content="vid_id")
  inspect(v.video.width, content="1280")
  inspect(v.video.height, content="720")
  inspect(v.video.duration, content="60")
}

///|
test "PaidMediaInfo from fixed JSON" {
  let json = @json.parse(
    #|{"star_count":50,"paid_media":[{"type":"preview","width":320,"height":240},{"type":"photo","photo":[{"file_id":"ph","file_unique_id":"phu","width":100,"height":100}]}]}
  )
  let info : PaidMediaInfo = @json.from_json(json)
  inspect(info.star_count, content="50")
  inspect(info.paid_media.length(), content="2")
  guard info.paid_media[0] is Preview(p) else { fail("Expected Preview") }
  inspect(p.width, content="Some(320)")
  guard info.paid_media[1] is Photo(ph) else { fail("Expected Photo") }
  inspect(ph.photo[0].file_id, content="ph")
}
