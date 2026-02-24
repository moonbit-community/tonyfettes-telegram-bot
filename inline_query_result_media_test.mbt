///|
test "InputTextMessageContent JSON round-trip" {
  let content = InputTextMessageContent::new(message_text="Hello, World!")
  let json = @json.to_json(content)
  let parsed : InputTextMessageContent = @json.from_json(json)
  inspect(parsed.message_text, content="Hello, World!")
}

///|
test "InlineQueryResultPhoto minimal JSON round-trip" {
  let result = InlineQueryResultPhoto::new(
    id="photo_1",
    photo_url="https://example.com/photo.jpg",
    thumbnail_url="https://example.com/thumb.jpg",
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultPhoto = @json.from_json(json)
  inspect(parsed.type_, content="photo")
  inspect(parsed.id, content="photo_1")
  inspect(parsed.photo_url, content="https://example.com/photo.jpg")
  inspect(parsed.thumbnail_url, content="https://example.com/thumb.jpg")
  inspect(parsed.photo_width, content="None")
  inspect(parsed.title, content="None")
}

///|
test "InlineQueryResultPhoto full JSON round-trip" {
  let result = InlineQueryResultPhoto::new(
    id="photo_2",
    photo_url="https://example.com/photo.jpg",
    thumbnail_url="https://example.com/thumb.jpg",
    photo_width=800,
    photo_height=600,
    title="A beautiful photo",
    description="This is a test photo",
    caption="Photo caption",
    parse_mode="HTML",
    show_caption_above_media=true,
    reply_markup=InlineKeyboardMarkup::new(inline_keyboard=[
      [InlineKeyboardButton::new(text="Click", callback_data="click")],
    ]),
    input_message_content=InputTextMessageContent::new(
      message_text="Selected photo",
    ),
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultPhoto = @json.from_json(json)
  inspect(parsed.type_, content="photo")
  inspect(parsed.id, content="photo_2")
  inspect(parsed.photo_width, content="Some(800)")
  inspect(parsed.photo_height, content="Some(600)")
  inspect(parsed.title, content="Some(\"A beautiful photo\")")
  inspect(parsed.description, content="Some(\"This is a test photo\")")
  inspect(parsed.caption, content="Some(\"Photo caption\")")
  inspect(parsed.parse_mode, content="Some(\"HTML\")")
  inspect(parsed.show_caption_above_media, content="Some(true)")
  guard parsed.reply_markup is Some(markup) else {
    fail("Expected reply_markup")
  }
  inspect(markup.inline_keyboard[0][0].text, content="Click")
  guard parsed.input_message_content is Some(content) else {
    fail("Expected input_message_content")
  }
  inspect(content.message_text, content="Selected photo")
}

///|
test "InlineQueryResultGif minimal JSON round-trip" {
  let result = InlineQueryResultGif::new(
    id="gif_1",
    gif_url="https://example.com/animation.gif",
    thumbnail_url="https://example.com/thumb.jpg",
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultGif = @json.from_json(json)
  inspect(parsed.type_, content="gif")
  inspect(parsed.id, content="gif_1")
  inspect(parsed.gif_url, content="https://example.com/animation.gif")
  inspect(parsed.thumbnail_url, content="https://example.com/thumb.jpg")
  inspect(parsed.gif_width, content="None")
  inspect(parsed.gif_duration, content="None")
}

///|
test "InlineQueryResultGif full JSON round-trip" {
  let result = InlineQueryResultGif::new(
    id="gif_2",
    gif_url="https://example.com/animation.gif",
    thumbnail_url="https://example.com/thumb.jpg",
    gif_width=320,
    gif_height=240,
    gif_duration=5,
    thumbnail_mime_type="image/jpeg",
    title="Animated GIF",
    caption="A cool animation",
    parse_mode="MarkdownV2",
    show_caption_above_media=false,
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultGif = @json.from_json(json)
  inspect(parsed.type_, content="gif")
  inspect(parsed.id, content="gif_2")
  inspect(parsed.gif_width, content="Some(320)")
  inspect(parsed.gif_height, content="Some(240)")
  inspect(parsed.gif_duration, content="Some(5)")
  inspect(parsed.thumbnail_mime_type, content="Some(\"image/jpeg\")")
  inspect(parsed.title, content="Some(\"Animated GIF\")")
  inspect(parsed.caption, content="Some(\"A cool animation\")")
  inspect(parsed.parse_mode, content="Some(\"MarkdownV2\")")
  inspect(parsed.show_caption_above_media, content="Some(false)")
}

///|
test "InlineQueryResultMpeg4Gif minimal JSON round-trip" {
  let result = InlineQueryResultMpeg4Gif::new(
    id="mpeg4_1",
    mpeg4_url="https://example.com/animation.mp4",
    thumbnail_url="https://example.com/thumb.jpg",
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultMpeg4Gif = @json.from_json(json)
  inspect(parsed.type_, content="mpeg4_gif")
  inspect(parsed.id, content="mpeg4_1")
  inspect(parsed.mpeg4_url, content="https://example.com/animation.mp4")
  inspect(parsed.thumbnail_url, content="https://example.com/thumb.jpg")
  inspect(parsed.mpeg4_width, content="None")
}

///|
test "InlineQueryResultMpeg4Gif full JSON round-trip" {
  let result = InlineQueryResultMpeg4Gif::new(
    id="mpeg4_2",
    mpeg4_url="https://example.com/animation.mp4",
    thumbnail_url="https://example.com/thumb.jpg",
    mpeg4_width=640,
    mpeg4_height=480,
    mpeg4_duration=10,
    thumbnail_mime_type="image/gif",
    title="MPEG4 Animation",
    caption="An MPEG4 animation",
    parse_mode="HTML",
    show_caption_above_media=true,
    reply_markup=InlineKeyboardMarkup::new(inline_keyboard=[
      [InlineKeyboardButton::new(text="View", url="https://example.com")],
    ]),
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultMpeg4Gif = @json.from_json(json)
  inspect(parsed.type_, content="mpeg4_gif")
  inspect(parsed.id, content="mpeg4_2")
  inspect(parsed.mpeg4_width, content="Some(640)")
  inspect(parsed.mpeg4_height, content="Some(480)")
  inspect(parsed.mpeg4_duration, content="Some(10)")
  inspect(parsed.thumbnail_mime_type, content="Some(\"image/gif\")")
  inspect(parsed.title, content="Some(\"MPEG4 Animation\")")
  inspect(parsed.show_caption_above_media, content="Some(true)")
  guard parsed.reply_markup is Some(markup) else {
    fail("Expected reply_markup")
  }
  inspect(markup.inline_keyboard[0][0].text, content="View")
  inspect(
    markup.inline_keyboard[0][0].url,
    content="Some(\"https://example.com\")",
  )
}

///|
test "InlineQueryResultVideo minimal JSON round-trip" {
  let result = InlineQueryResultVideo::new(
    id="video_1",
    video_url="https://example.com/video.mp4",
    mime_type="video/mp4",
    thumbnail_url="https://example.com/thumb.jpg",
    title="A Video",
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultVideo = @json.from_json(json)
  inspect(parsed.type_, content="video")
  inspect(parsed.id, content="video_1")
  inspect(parsed.video_url, content="https://example.com/video.mp4")
  inspect(parsed.mime_type, content="video/mp4")
  inspect(parsed.thumbnail_url, content="https://example.com/thumb.jpg")
  inspect(parsed.title, content="A Video")
  inspect(parsed.video_width, content="None")
  inspect(parsed.description, content="None")
}

///|
test "InlineQueryResultVideo full JSON round-trip" {
  let result = InlineQueryResultVideo::new(
    id="video_2",
    video_url="https://example.com/video.mp4",
    mime_type="video/mp4",
    thumbnail_url="https://example.com/thumb.jpg",
    title="Full Video",
    caption="Video caption",
    parse_mode="HTML",
    show_caption_above_media=true,
    video_width=1920,
    video_height=1080,
    video_duration=120,
    description="A high quality video",
    reply_markup=InlineKeyboardMarkup::new(inline_keyboard=[
      [InlineKeyboardButton::new(text="Watch", callback_data="watch")],
    ]),
    input_message_content=InputTextMessageContent::new(
      message_text="You selected a video",
    ),
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultVideo = @json.from_json(json)
  inspect(parsed.type_, content="video")
  inspect(parsed.id, content="video_2")
  inspect(parsed.title, content="Full Video")
  inspect(parsed.caption, content="Some(\"Video caption\")")
  inspect(parsed.parse_mode, content="Some(\"HTML\")")
  inspect(parsed.show_caption_above_media, content="Some(true)")
  inspect(parsed.video_width, content="Some(1920)")
  inspect(parsed.video_height, content="Some(1080)")
  inspect(parsed.video_duration, content="Some(120)")
  inspect(parsed.description, content="Some(\"A high quality video\")")
  guard parsed.reply_markup is Some(markup) else {
    fail("Expected reply_markup")
  }
  inspect(markup.inline_keyboard[0][0].text, content="Watch")
  guard parsed.input_message_content is Some(content) else {
    fail("Expected input_message_content")
  }
  inspect(content.message_text, content="You selected a video")
}

///|
test "InlineQueryResultPhoto with caption_entities JSON round-trip" {
  let result = InlineQueryResultPhoto::new(
    id="photo_entities",
    photo_url="https://example.com/photo.jpg",
    thumbnail_url="https://example.com/thumb.jpg",
    caption="Bold text",
    caption_entities=[MessageEntity::new(type_="bold", offset=0, length=4)],
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultPhoto = @json.from_json(json)
  inspect(parsed.caption, content="Some(\"Bold text\")")
  guard parsed.caption_entities is Some(entities) else {
    fail("Expected caption_entities")
  }
  inspect(entities.length(), content="1")
  inspect(entities[0].type_, content="bold")
  inspect(entities[0].offset, content="0")
  inspect(entities[0].length, content="4")
}

///|
test "InlineQueryResultPhoto from fixed JSON" {
  let json = @json.parse(
    #|{"type":"photo","id":"ph1","photo_url":"https://example.com/img.jpg","thumbnail_url":"https://example.com/thumb.jpg","photo_width":1920,"photo_height":1080,"title":"Sunset","caption":"Beautiful sunset"}
  )
  let result : InlineQueryResultPhoto = @json.from_json(json)
  inspect(result.type_, content="photo")
  inspect(result.id, content="ph1")
  inspect(result.photo_url, content="https://example.com/img.jpg")
  inspect(result.thumbnail_url, content="https://example.com/thumb.jpg")
  inspect(result.photo_width, content="Some(1920)")
  inspect(result.photo_height, content="Some(1080)")
  inspect(result.title, content="Some(\"Sunset\")")
  inspect(result.caption, content="Some(\"Beautiful sunset\")")
  inspect(result.description, content="None")
  inspect(result.reply_markup, content="None")
}

///|
test "InlineQueryResultPhoto minimal from fixed JSON" {
  let json = @json.parse(
    #|{"type":"photo","id":"ph2","photo_url":"https://example.com/photo2.jpg","thumbnail_url":"https://example.com/t2.jpg"}
  )
  let result : InlineQueryResultPhoto = @json.from_json(json)
  inspect(result.type_, content="photo")
  inspect(result.id, content="ph2")
  inspect(result.photo_width, content="None")
  inspect(result.photo_height, content="None")
  inspect(result.title, content="None")
  inspect(result.caption, content="None")
  inspect(result.input_message_content, content="None")
}

///|
test "InlineQueryResultGif from fixed JSON" {
  let json = @json.parse(
    #|{"type":"gif","id":"gif1","gif_url":"https://example.com/anim.gif","thumbnail_url":"https://example.com/t.jpg","gif_width":480,"gif_height":270,"gif_duration":3,"title":"Cool GIF"}
  )
  let result : InlineQueryResultGif = @json.from_json(json)
  inspect(result.type_, content="gif")
  inspect(result.id, content="gif1")
  inspect(result.gif_url, content="https://example.com/anim.gif")
  inspect(result.thumbnail_url, content="https://example.com/t.jpg")
  inspect(result.gif_width, content="Some(480)")
  inspect(result.gif_height, content="Some(270)")
  inspect(result.gif_duration, content="Some(3)")
  inspect(result.title, content="Some(\"Cool GIF\")")
  inspect(result.caption, content="None")
  inspect(result.thumbnail_mime_type, content="None")
}

///|
test "InlineQueryResultGif minimal from fixed JSON" {
  let json = @json.parse(
    #|{"type":"gif","id":"gif2","gif_url":"https://example.com/simple.gif","thumbnail_url":"https://example.com/ts.jpg"}
  )
  let result : InlineQueryResultGif = @json.from_json(json)
  inspect(result.type_, content="gif")
  inspect(result.id, content="gif2")
  inspect(result.gif_width, content="None")
  inspect(result.gif_duration, content="None")
  inspect(result.title, content="None")
  inspect(result.show_caption_above_media, content="None")
}

///|
test "InlineQueryResultMpeg4Gif from fixed JSON" {
  let json = @json.parse(
    #|{"type":"mpeg4_gif","id":"mp4g1","mpeg4_url":"https://example.com/clip.mp4","thumbnail_url":"https://example.com/tc.jpg","mpeg4_width":640,"mpeg4_height":360,"mpeg4_duration":8,"thumbnail_mime_type":"image/jpeg","title":"MP4 Clip"}
  )
  let result : InlineQueryResultMpeg4Gif = @json.from_json(json)
  inspect(result.type_, content="mpeg4_gif")
  inspect(result.id, content="mp4g1")
  inspect(result.mpeg4_url, content="https://example.com/clip.mp4")
  inspect(result.thumbnail_url, content="https://example.com/tc.jpg")
  inspect(result.mpeg4_width, content="Some(640)")
  inspect(result.mpeg4_height, content="Some(360)")
  inspect(result.mpeg4_duration, content="Some(8)")
  inspect(result.thumbnail_mime_type, content="Some(\"image/jpeg\")")
  inspect(result.title, content="Some(\"MP4 Clip\")")
  inspect(result.caption, content="None")
}

///|
test "InlineQueryResultMpeg4Gif minimal from fixed JSON" {
  let json = @json.parse(
    #|{"type":"mpeg4_gif","id":"mp4g2","mpeg4_url":"https://example.com/minimal.mp4","thumbnail_url":"https://example.com/tm.jpg"}
  )
  let result : InlineQueryResultMpeg4Gif = @json.from_json(json)
  inspect(result.type_, content="mpeg4_gif")
  inspect(result.id, content="mp4g2")
  inspect(result.mpeg4_width, content="None")
  inspect(result.title, content="None")
  inspect(result.input_message_content, content="None")
}

///|
test "InlineQueryResultVideo from fixed JSON" {
  let json = @json.parse(
    #|{"type":"video","id":"vid1","video_url":"https://example.com/movie.mp4","mime_type":"video/mp4","thumbnail_url":"https://example.com/tv.jpg","title":"Great Movie","video_width":1920,"video_height":1080,"video_duration":7200,"description":"An award-winning film"}
  )
  let result : InlineQueryResultVideo = @json.from_json(json)
  inspect(result.type_, content="video")
  inspect(result.id, content="vid1")
  inspect(result.video_url, content="https://example.com/movie.mp4")
  inspect(result.mime_type, content="video/mp4")
  inspect(result.thumbnail_url, content="https://example.com/tv.jpg")
  inspect(result.title, content="Great Movie")
  inspect(result.video_width, content="Some(1920)")
  inspect(result.video_height, content="Some(1080)")
  inspect(result.video_duration, content="Some(7200)")
  inspect(result.description, content="Some(\"An award-winning film\")")
  inspect(result.caption, content="None")
  inspect(result.reply_markup, content="None")
}

///|
test "InlineQueryResultVideo minimal from fixed JSON" {
  let json = @json.parse(
    #|{"type":"video","id":"vid2","video_url":"https://example.com/clip.mp4","mime_type":"video/mp4","thumbnail_url":"https://example.com/tc.jpg","title":"Short Clip"}
  )
  let result : InlineQueryResultVideo = @json.from_json(json)
  inspect(result.type_, content="video")
  inspect(result.id, content="vid2")
  inspect(result.mime_type, content="video/mp4")
  inspect(result.title, content="Short Clip")
  inspect(result.video_width, content="None")
  inspect(result.video_duration, content="None")
  inspect(result.description, content="None")
  inspect(result.input_message_content, content="None")
}
