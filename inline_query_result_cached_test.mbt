///|
test "CachedInputMessageContent JSON round-trip" {
  let content = CachedInputMessageContent::new(message_text="Hello, World!")
  let json = @json.to_json(content)
  let parsed : CachedInputMessageContent = @json.from_json(json)
  inspect(parsed.message_text, content="Hello, World!")
}

///|
test "InlineQueryResultCachedPhoto minimal JSON round-trip" {
  let result = InlineQueryResultCachedPhoto::new(
    id="photo_1",
    photo_file_id="AgACAgIAAxkBAAI",
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedPhoto = @json.from_json(json)
  inspect(parsed.type_, content="photo")
  inspect(parsed.id, content="photo_1")
  inspect(parsed.photo_file_id, content="AgACAgIAAxkBAAI")
  inspect(parsed.title, content="None")
  inspect(parsed.caption, content="None")
}

///|
test "InlineQueryResultCachedPhoto full JSON round-trip" {
  let result = InlineQueryResultCachedPhoto::new(
    id="photo_2",
    photo_file_id="AgACAgIAAxkBAAI",
    title="Photo Title",
    description="A nice photo",
    caption="Photo caption",
    parse_mode="HTML",
    caption_entities=[MessageEntity::new(type_="bold", offset=0, length=5)],
    show_caption_above_media=true,
    reply_markup=InlineKeyboardMarkup::new(inline_keyboard=[
      [InlineKeyboardButton::new(text="Click", callback_data="data")],
    ]),
    input_message_content=CachedInputMessageContent::new(
      message_text="Custom message",
    ),
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedPhoto = @json.from_json(json)
  inspect(parsed.type_, content="photo")
  inspect(parsed.id, content="photo_2")
  inspect(parsed.title, content="Some(\"Photo Title\")")
  inspect(parsed.description, content="Some(\"A nice photo\")")
  inspect(parsed.caption, content="Some(\"Photo caption\")")
  inspect(parsed.parse_mode, content="Some(\"HTML\")")
  inspect(parsed.show_caption_above_media, content="Some(true)")
  guard parsed.caption_entities is Some(entities) else { panic() }
  inspect(entities.length(), content="1")
  guard parsed.reply_markup is Some(markup) else { panic() }
  inspect(markup.inline_keyboard[0][0].text, content="Click")
  guard parsed.input_message_content is Some(content) else { panic() }
  inspect(content.message_text, content="Custom message")
}

///|
test "InlineQueryResultCachedGif minimal JSON round-trip" {
  let result = InlineQueryResultCachedGif::new(
    id="gif_1",
    gif_file_id="CgACAgIAAxkBAAI",
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedGif = @json.from_json(json)
  inspect(parsed.type_, content="gif")
  inspect(parsed.id, content="gif_1")
  inspect(parsed.gif_file_id, content="CgACAgIAAxkBAAI")
  inspect(parsed.title, content="None")
}

///|
test "InlineQueryResultCachedGif full JSON round-trip" {
  let result = InlineQueryResultCachedGif::new(
    id="gif_2",
    gif_file_id="CgACAgIAAxkBAAI",
    title="Funny GIF",
    caption="LOL",
    parse_mode="Markdown",
    show_caption_above_media=false,
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedGif = @json.from_json(json)
  inspect(parsed.type_, content="gif")
  inspect(parsed.title, content="Some(\"Funny GIF\")")
  inspect(parsed.caption, content="Some(\"LOL\")")
  inspect(parsed.parse_mode, content="Some(\"Markdown\")")
  inspect(parsed.show_caption_above_media, content="Some(false)")
}

///|
test "InlineQueryResultCachedMpeg4Gif minimal JSON round-trip" {
  let result = InlineQueryResultCachedMpeg4Gif::new(
    id="mpeg4_1",
    mpeg4_file_id="BgACAgIAAxkBAAI",
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedMpeg4Gif = @json.from_json(json)
  inspect(parsed.type_, content="mpeg4_gif")
  inspect(parsed.id, content="mpeg4_1")
  inspect(parsed.mpeg4_file_id, content="BgACAgIAAxkBAAI")
}

///|
test "InlineQueryResultCachedMpeg4Gif full JSON round-trip" {
  let result = InlineQueryResultCachedMpeg4Gif::new(
    id="mpeg4_2",
    mpeg4_file_id="BgACAgIAAxkBAAI",
    title="MPEG4 Animation",
    caption="Cool animation",
    parse_mode="HTML",
    show_caption_above_media=true,
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedMpeg4Gif = @json.from_json(json)
  inspect(parsed.type_, content="mpeg4_gif")
  inspect(parsed.title, content="Some(\"MPEG4 Animation\")")
  inspect(parsed.caption, content="Some(\"Cool animation\")")
  inspect(parsed.show_caption_above_media, content="Some(true)")
}

///|
test "InlineQueryResultCachedSticker minimal JSON round-trip" {
  let result = InlineQueryResultCachedSticker::new(
    id="sticker_1",
    sticker_file_id="CAACAgIAAxkBAAI",
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedSticker = @json.from_json(json)
  inspect(parsed.type_, content="sticker")
  inspect(parsed.id, content="sticker_1")
  inspect(parsed.sticker_file_id, content="CAACAgIAAxkBAAI")
  inspect(parsed.reply_markup, content="None")
  inspect(parsed.input_message_content, content="None")
}

///|
test "InlineQueryResultCachedSticker full JSON round-trip" {
  let result = InlineQueryResultCachedSticker::new(
    id="sticker_2",
    sticker_file_id="CAACAgIAAxkBAAI",
    reply_markup=InlineKeyboardMarkup::new(inline_keyboard=[
      [InlineKeyboardButton::new(text="Send", callback_data="send")],
    ]),
    input_message_content=CachedInputMessageContent::new(
      message_text="Sticker sent!",
    ),
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedSticker = @json.from_json(json)
  inspect(parsed.type_, content="sticker")
  guard parsed.reply_markup is Some(markup) else { panic() }
  inspect(markup.inline_keyboard[0][0].text, content="Send")
  guard parsed.input_message_content is Some(content) else { panic() }
  inspect(content.message_text, content="Sticker sent!")
}

///|
test "InlineQueryResultCachedDocument minimal JSON round-trip" {
  let result = InlineQueryResultCachedDocument::new(
    id="doc_1",
    title="Document Title",
    document_file_id="BQACAgIAAxkBAAI",
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedDocument = @json.from_json(json)
  inspect(parsed.type_, content="document")
  inspect(parsed.id, content="doc_1")
  inspect(parsed.title, content="Document Title")
  inspect(parsed.document_file_id, content="BQACAgIAAxkBAAI")
  inspect(parsed.description, content="None")
}

///|
test "InlineQueryResultCachedDocument full JSON round-trip" {
  let result = InlineQueryResultCachedDocument::new(
    id="doc_2",
    title="Important Document",
    document_file_id="BQACAgIAAxkBAAI",
    description="A very important document",
    caption="Read this!",
    parse_mode="MarkdownV2",
    caption_entities=[MessageEntity::new(type_="italic", offset=0, length=4)],
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedDocument = @json.from_json(json)
  inspect(parsed.type_, content="document")
  inspect(parsed.title, content="Important Document")
  inspect(parsed.description, content="Some(\"A very important document\")")
  inspect(parsed.caption, content="Some(\"Read this!\")")
  inspect(parsed.parse_mode, content="Some(\"MarkdownV2\")")
  guard parsed.caption_entities is Some(entities) else { panic() }
  inspect(entities.length(), content="1")
  inspect(entities[0].type_, content="italic")
}

///|
test "InlineQueryResultCachedVideo minimal JSON round-trip" {
  let result = InlineQueryResultCachedVideo::new(
    id="video_1",
    video_file_id="BAACAgIAAxkBAAI",
    title="Video Title",
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedVideo = @json.from_json(json)
  inspect(parsed.type_, content="video")
  inspect(parsed.id, content="video_1")
  inspect(parsed.video_file_id, content="BAACAgIAAxkBAAI")
  inspect(parsed.title, content="Video Title")
  inspect(parsed.description, content="None")
}

///|
test "InlineQueryResultCachedVideo full JSON round-trip" {
  let result = InlineQueryResultCachedVideo::new(
    id="video_2",
    video_file_id="BAACAgIAAxkBAAI",
    title="Amazing Video",
    description="Watch this amazing video",
    caption="Must see!",
    parse_mode="HTML",
    show_caption_above_media=true,
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedVideo = @json.from_json(json)
  inspect(parsed.type_, content="video")
  inspect(parsed.title, content="Amazing Video")
  inspect(parsed.description, content="Some(\"Watch this amazing video\")")
  inspect(parsed.caption, content="Some(\"Must see!\")")
  inspect(parsed.show_caption_above_media, content="Some(true)")
}

///|
test "InlineQueryResultCachedVoice minimal JSON round-trip" {
  let result = InlineQueryResultCachedVoice::new(
    id="voice_1",
    voice_file_id="AwACAgIAAxkBAAI",
    title="Voice Message",
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedVoice = @json.from_json(json)
  inspect(parsed.type_, content="voice")
  inspect(parsed.id, content="voice_1")
  inspect(parsed.voice_file_id, content="AwACAgIAAxkBAAI")
  inspect(parsed.title, content="Voice Message")
  inspect(parsed.caption, content="None")
}

///|
test "InlineQueryResultCachedVoice full JSON round-trip" {
  let result = InlineQueryResultCachedVoice::new(
    id="voice_2",
    voice_file_id="AwACAgIAAxkBAAI",
    title="Important Voice Note",
    caption="Listen carefully",
    parse_mode="HTML",
    caption_entities=[MessageEntity::new(type_="underline", offset=0, length=6)],
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedVoice = @json.from_json(json)
  inspect(parsed.type_, content="voice")
  inspect(parsed.title, content="Important Voice Note")
  inspect(parsed.caption, content="Some(\"Listen carefully\")")
  guard parsed.caption_entities is Some(entities) else { panic() }
  inspect(entities[0].type_, content="underline")
}

///|
test "InlineQueryResultCachedAudio minimal JSON round-trip" {
  let result = InlineQueryResultCachedAudio::new(
    id="audio_1",
    audio_file_id="CQACAgIAAxkBAAI",
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedAudio = @json.from_json(json)
  inspect(parsed.type_, content="audio")
  inspect(parsed.id, content="audio_1")
  inspect(parsed.audio_file_id, content="CQACAgIAAxkBAAI")
  inspect(parsed.caption, content="None")
}

///|
test "InlineQueryResultCachedAudio full JSON round-trip" {
  let result = InlineQueryResultCachedAudio::new(
    id="audio_2",
    audio_file_id="CQACAgIAAxkBAAI",
    caption="Great song!",
    parse_mode="Markdown",
    caption_entities=[MessageEntity::new(type_="bold", offset=0, length=5)],
    reply_markup=InlineKeyboardMarkup::new(inline_keyboard=[
      [InlineKeyboardButton::new(text="Download", url="https://example.com")],
    ]),
    input_message_content=CachedInputMessageContent::new(
      message_text="Here is the audio",
    ),
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultCachedAudio = @json.from_json(json)
  inspect(parsed.type_, content="audio")
  inspect(parsed.caption, content="Some(\"Great song!\")")
  inspect(parsed.parse_mode, content="Some(\"Markdown\")")
  guard parsed.caption_entities is Some(entities) else { panic() }
  inspect(entities.length(), content="1")
  guard parsed.reply_markup is Some(markup) else { panic() }
  inspect(markup.inline_keyboard[0][0].text, content="Download")
  guard parsed.input_message_content is Some(content) else { panic() }
  inspect(content.message_text, content="Here is the audio")
}

///|
test "InlineQueryResultCachedPhoto from fixed JSON" {
  let json = @json.parse(
    #|{"type":"photo","id":"cp1","photo_file_id":"AgACAgIAAxkBAAIcp1","title":"Fixed Photo","caption":"A cached photo"}
  )
  let result : InlineQueryResultCachedPhoto = @json.from_json(json)
  inspect(result.type_, content="photo")
  inspect(result.id, content="cp1")
  inspect(result.photo_file_id, content="AgACAgIAAxkBAAIcp1")
  inspect(result.title, content="Some(\"Fixed Photo\")")
  inspect(result.caption, content="Some(\"A cached photo\")")
  inspect(result.description, content="None")
  inspect(result.parse_mode, content="None")
  inspect(result.reply_markup, content="None")
}

///|
test "InlineQueryResultCachedPhoto minimal from fixed JSON" {
  let json = @json.parse(
    #|{"type":"photo","id":"cp2","photo_file_id":"AgACAgIAAxkBAAIcp2"}
  )
  let result : InlineQueryResultCachedPhoto = @json.from_json(json)
  inspect(result.type_, content="photo")
  inspect(result.id, content="cp2")
  inspect(result.title, content="None")
  inspect(result.caption, content="None")
  inspect(result.input_message_content, content="None")
}

///|
test "InlineQueryResultCachedGif from fixed JSON" {
  let json = @json.parse(
    #|{"type":"gif","id":"cg1","gif_file_id":"CgACAgIAAxkBAAIcg1","title":"Fixed GIF","caption":"Funny","parse_mode":"HTML"}
  )
  let result : InlineQueryResultCachedGif = @json.from_json(json)
  inspect(result.type_, content="gif")
  inspect(result.id, content="cg1")
  inspect(result.gif_file_id, content="CgACAgIAAxkBAAIcg1")
  inspect(result.title, content="Some(\"Fixed GIF\")")
  inspect(result.caption, content="Some(\"Funny\")")
  inspect(result.parse_mode, content="Some(\"HTML\")")
  inspect(result.show_caption_above_media, content="None")
}

///|
test "InlineQueryResultCachedGif minimal from fixed JSON" {
  let json = @json.parse(
    #|{"type":"gif","id":"cg2","gif_file_id":"CgACAgIAAxkBAAIcg2"}
  )
  let result : InlineQueryResultCachedGif = @json.from_json(json)
  inspect(result.type_, content="gif")
  inspect(result.title, content="None")
  inspect(result.caption, content="None")
}

///|
test "InlineQueryResultCachedMpeg4Gif from fixed JSON" {
  let json = @json.parse(
    #|{"type":"mpeg4_gif","id":"cm1","mpeg4_file_id":"BgACAgIAAxkBAAIcm1","caption":"Cool video","show_caption_above_media":true}
  )
  let result : InlineQueryResultCachedMpeg4Gif = @json.from_json(json)
  inspect(result.type_, content="mpeg4_gif")
  inspect(result.id, content="cm1")
  inspect(result.mpeg4_file_id, content="BgACAgIAAxkBAAIcm1")
  inspect(result.caption, content="Some(\"Cool video\")")
  inspect(result.show_caption_above_media, content="Some(true)")
  inspect(result.title, content="None")
}

///|
test "InlineQueryResultCachedSticker from fixed JSON" {
  let json = @json.parse(
    #|{"type":"sticker","id":"cs1","sticker_file_id":"CAACAgIAAxkBAAIcs1"}
  )
  let result : InlineQueryResultCachedSticker = @json.from_json(json)
  inspect(result.type_, content="sticker")
  inspect(result.id, content="cs1")
  inspect(result.sticker_file_id, content="CAACAgIAAxkBAAIcs1")
  inspect(result.reply_markup, content="None")
  inspect(result.input_message_content, content="None")
}

///|
test "InlineQueryResultCachedDocument from fixed JSON" {
  let json = @json.parse(
    #|{"type":"document","id":"cd1","title":"My Doc","document_file_id":"BQACAgIAAxkBAAIcd1","description":"An important file","caption":"See attached"}
  )
  let result : InlineQueryResultCachedDocument = @json.from_json(json)
  inspect(result.type_, content="document")
  inspect(result.id, content="cd1")
  inspect(result.title, content="My Doc")
  inspect(result.document_file_id, content="BQACAgIAAxkBAAIcd1")
  inspect(result.description, content="Some(\"An important file\")")
  inspect(result.caption, content="Some(\"See attached\")")
  inspect(result.parse_mode, content="None")
}

///|
test "InlineQueryResultCachedDocument minimal from fixed JSON" {
  let json = @json.parse(
    #|{"type":"document","id":"cd2","title":"Minimal Doc","document_file_id":"BQACAgIAAxkBAAIcd2"}
  )
  let result : InlineQueryResultCachedDocument = @json.from_json(json)
  inspect(result.type_, content="document")
  inspect(result.title, content="Minimal Doc")
  inspect(result.description, content="None")
  inspect(result.caption, content="None")
}

///|
test "InlineQueryResultCachedVideo from fixed JSON" {
  let json = @json.parse(
    #|{"type":"video","id":"cv1","video_file_id":"BAACAgIAAxkBAAIcv1","title":"My Video","description":"Great video","caption":"Watch now"}
  )
  let result : InlineQueryResultCachedVideo = @json.from_json(json)
  inspect(result.type_, content="video")
  inspect(result.id, content="cv1")
  inspect(result.video_file_id, content="BAACAgIAAxkBAAIcv1")
  inspect(result.title, content="My Video")
  inspect(result.description, content="Some(\"Great video\")")
  inspect(result.caption, content="Some(\"Watch now\")")
  inspect(result.show_caption_above_media, content="None")
}

///|
test "InlineQueryResultCachedVoice from fixed JSON" {
  let json = @json.parse(
    #|{"type":"voice","id":"cvo1","voice_file_id":"AwACAgIAAxkBAAIcvo1","title":"My Voice Note","caption":"Listen!"}
  )
  let result : InlineQueryResultCachedVoice = @json.from_json(json)
  inspect(result.type_, content="voice")
  inspect(result.id, content="cvo1")
  inspect(result.voice_file_id, content="AwACAgIAAxkBAAIcvo1")
  inspect(result.title, content="My Voice Note")
  inspect(result.caption, content="Some(\"Listen!\")")
  inspect(result.parse_mode, content="None")
}

///|
test "InlineQueryResultCachedVoice minimal from fixed JSON" {
  let json = @json.parse(
    #|{"type":"voice","id":"cvo2","voice_file_id":"AwACAgIAAxkBAAIcvo2","title":"Brief Note"}
  )
  let result : InlineQueryResultCachedVoice = @json.from_json(json)
  inspect(result.type_, content="voice")
  inspect(result.title, content="Brief Note")
  inspect(result.caption, content="None")
  inspect(result.caption_entities, content="None")
}

///|
test "InlineQueryResultCachedAudio from fixed JSON" {
  let json = @json.parse(
    #|{"type":"audio","id":"ca1","audio_file_id":"CQACAgIAAxkBAAIca1","caption":"Great track","parse_mode":"Markdown"}
  )
  let result : InlineQueryResultCachedAudio = @json.from_json(json)
  inspect(result.type_, content="audio")
  inspect(result.id, content="ca1")
  inspect(result.audio_file_id, content="CQACAgIAAxkBAAIca1")
  inspect(result.caption, content="Some(\"Great track\")")
  inspect(result.parse_mode, content="Some(\"Markdown\")")
  inspect(result.reply_markup, content="None")
}

///|
test "InlineQueryResultCachedAudio minimal from fixed JSON" {
  let json = @json.parse(
    #|{"type":"audio","id":"ca2","audio_file_id":"CQACAgIAAxkBAAIca2"}
  )
  let result : InlineQueryResultCachedAudio = @json.from_json(json)
  inspect(result.type_, content="audio")
  inspect(result.id, content="ca2")
  inspect(result.caption, content="None")
  inspect(result.input_message_content, content="None")
}
