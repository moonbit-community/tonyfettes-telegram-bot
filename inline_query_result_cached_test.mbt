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
