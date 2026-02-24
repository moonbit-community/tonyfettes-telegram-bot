///|
test "PhotoSize JSON round-trip" {
  let photo = PhotoSize::new(
    file_id="photo123",
    file_unique_id="unique456",
    width=100,
    height=200,
  )
  let json = @json.to_json(photo)
  let parsed : PhotoSize = @json.from_json(json)
  inspect(parsed.file_id, content="photo123")
  inspect(parsed.file_unique_id, content="unique456")
  inspect(parsed.width, content="100")
  inspect(parsed.height, content="200")
}

///|
test "FilePlaceholder JSON round-trip" {
  let file = FilePlaceholder::new(file_id="file123", file_unique_id="unique789")
  let json = @json.to_json(file)
  let parsed : FilePlaceholder = @json.from_json(json)
  inspect(parsed.file_id, content="file123")
  inspect(parsed.file_unique_id, content="unique789")
}

///|
test "MaskPosition JSON round-trip" {
  let mask = MaskPosition::new(
    point="forehead",
    x_shift=0.5,
    y_shift=-0.3,
    scale=1.2,
  )
  let json = @json.to_json(mask)
  let parsed : MaskPosition = @json.from_json(json)
  inspect(parsed.point, content="forehead")
  inspect(parsed.x_shift, content="0.5")
  inspect(parsed.y_shift, content="-0.3")
  inspect(parsed.scale, content="1.2")
}

///|
test "Sticker JSON round-trip minimal" {
  let sticker = Sticker::new(
    file_id="sticker123",
    file_unique_id="unique456",
    type_="regular",
    width=512,
    height=512,
    is_animated=false,
    is_video=false,
  )
  let json = @json.to_json(sticker)
  let parsed : Sticker = @json.from_json(json)
  inspect(parsed.file_id, content="sticker123")
  inspect(parsed.file_unique_id, content="unique456")
  inspect(parsed.type_, content="regular")
  inspect(parsed.width, content="512")
  inspect(parsed.height, content="512")
  inspect(parsed.is_animated, content="false")
  inspect(parsed.is_video, content="false")
  inspect(parsed.thumbnail, content="None")
  inspect(parsed.emoji, content="None")
}

///|
test "Sticker JSON round-trip with optionals" {
  let thumbnail = PhotoSize::new(
    file_id="thumb123",
    file_unique_id="thumbunique",
    width=128,
    height=128,
  )
  let mask = MaskPosition::new(
    point="eyes",
    x_shift=0.0,
    y_shift=0.1,
    scale=1.0,
  )
  let sticker = Sticker::new(
    file_id="sticker456",
    file_unique_id="unique789",
    type_="mask",
    width=512,
    height=512,
    is_animated=true,
    is_video=false,
    thumbnail~,
    emoji="U+1F600",
    set_name="my_sticker_set",
    mask_position=mask,
    file_size=12345L,
  )
  let json = @json.to_json(sticker)
  let parsed : Sticker = @json.from_json(json)
  inspect(parsed.file_id, content="sticker456")
  inspect(parsed.type_, content="mask")
  inspect(parsed.is_animated, content="true")
  inspect(parsed.emoji, content="Some(\"U+1F600\")")
  inspect(parsed.set_name, content="Some(\"my_sticker_set\")")
  inspect(parsed.file_size, content="Some(12345)")
  guard parsed.thumbnail is Some(t) else { fail("Expected thumbnail") }
  inspect(t.file_id, content="thumb123")
  guard parsed.mask_position is Some(m) else { fail("Expected mask_position") }
  inspect(m.point, content="eyes")
}

///|
test "StickerSet JSON round-trip" {
  let sticker1 = Sticker::new(
    file_id="s1",
    file_unique_id="u1",
    type_="regular",
    width=512,
    height=512,
    is_animated=false,
    is_video=false,
    emoji="U+1F60A",
  )
  let sticker2 = Sticker::new(
    file_id="s2",
    file_unique_id="u2",
    type_="regular",
    width=512,
    height=512,
    is_animated=false,
    is_video=false,
    emoji="U+1F60B",
  )
  let set = StickerSet::new(
    name="test_sticker_set",
    title="Test Sticker Set",
    sticker_type="regular",
    stickers=[sticker1, sticker2],
  )
  let json = @json.to_json(set)
  let parsed : StickerSet = @json.from_json(json)
  inspect(parsed.name, content="test_sticker_set")
  inspect(parsed.title, content="Test Sticker Set")
  inspect(parsed.sticker_type, content="regular")
  inspect(parsed.stickers.length(), content="2")
  inspect(parsed.thumbnail, content="None")
}

///|
test "StickerSet JSON round-trip with thumbnail" {
  let sticker = Sticker::new(
    file_id="s1",
    file_unique_id="u1",
    type_="custom_emoji",
    width=100,
    height=100,
    is_animated=true,
    is_video=false,
  )
  let thumb = PhotoSize::new(
    file_id="thumb_id",
    file_unique_id="thumb_unique",
    width=64,
    height=64,
  )
  let set = StickerSet::new(
    name="emoji_set",
    title="Emoji Set",
    sticker_type="custom_emoji",
    stickers=[sticker],
    thumbnail=thumb,
  )
  let json = @json.to_json(set)
  let parsed : StickerSet = @json.from_json(json)
  inspect(parsed.name, content="emoji_set")
  inspect(parsed.sticker_type, content="custom_emoji")
  guard parsed.thumbnail is Some(t) else { fail("Expected thumbnail") }
  inspect(t.file_id, content="thumb_id")
}

///|
test "InputSticker JSON round-trip minimal" {
  let input = InputSticker::new(sticker="CAACAgIAAxkBAAI...", format="static", emoji_list=[
    "U+1F600", "U+1F601",
  ])
  let json = @json.to_json(input)
  let parsed : InputSticker = @json.from_json(json)
  inspect(parsed.sticker, content="CAACAgIAAxkBAAI...")
  inspect(parsed.format, content="static")
  inspect(parsed.emoji_list.length(), content="2")
  inspect(parsed.mask_position, content="None")
  inspect(parsed.keywords, content="None")
}

///|
test "InputSticker JSON round-trip with optionals" {
  let mask = MaskPosition::new(
    point="chin",
    x_shift=0.2,
    y_shift=0.3,
    scale=0.9,
  )
  let input = InputSticker::new(
    sticker="https://example.com/sticker.webp",
    format="animated",
    emoji_list=["U+1F923"],
    mask_position=mask,
    keywords=["funny", "laugh", "lol"],
  )
  let json = @json.to_json(input)
  let parsed : InputSticker = @json.from_json(json)
  inspect(parsed.sticker, content="https://example.com/sticker.webp")
  inspect(parsed.format, content="animated")
  guard parsed.mask_position is Some(m) else { fail("Expected mask_position") }
  inspect(m.point, content="chin")
  guard parsed.keywords is Some(kw) else { fail("Expected keywords") }
  inspect(kw.length(), content="3")
  inspect(kw[0], content="funny")
}

///|
test "MaskPosition from fixed JSON" {
  let json = @json.parse(
    #|{"point":"forehead","x_shift":0.5,"y_shift":-0.3,"scale":1.2}
  )
  let mask : MaskPosition = @json.from_json(json)
  inspect(mask.point, content="forehead")
  inspect(mask.x_shift, content="0.5")
  inspect(mask.y_shift, content="-0.3")
  inspect(mask.scale, content="1.2")
}

///|
test "Sticker from fixed JSON minimal" {
  let json = @json.parse(
    #|{"file_id":"BQACAgIAAxkBAAI","file_unique_id":"AgADLAADTr2xSw","type":"regular","width":512,"height":512,"is_animated":false,"is_video":false}
  )
  let sticker : Sticker = @json.from_json(json)
  inspect(sticker.file_id, content="BQACAgIAAxkBAAI")
  inspect(sticker.file_unique_id, content="AgADLAADTr2xSw")
  inspect(sticker.type_, content="regular")
  inspect(sticker.width, content="512")
  inspect(sticker.height, content="512")
  inspect(sticker.is_animated, content="false")
  inspect(sticker.is_video, content="false")
  inspect(sticker.emoji, content="None")
  inspect(sticker.set_name, content="None")
  inspect(sticker.file_size, content="None")
}

///|
test "Sticker from fixed JSON with optional fields" {
  let json = @json.parse(
    #|{"file_id":"BQACAgIAAxkBAAJ","file_unique_id":"AgADMAADTr2xSw","type":"mask","width":512,"height":512,"is_animated":true,"is_video":false,"emoji":"U+1F601","set_name":"my_masks","file_size":54321,"mask_position":{"point":"eyes","x_shift":0.0,"y_shift":0.2,"scale":1.0}}
  )
  let sticker : Sticker = @json.from_json(json)
  inspect(sticker.file_id, content="BQACAgIAAxkBAAJ")
  inspect(sticker.type_, content="mask")
  inspect(sticker.is_animated, content="true")
  inspect(sticker.emoji, content="Some(\"U+1F601\")")
  inspect(sticker.set_name, content="Some(\"my_masks\")")
  inspect(sticker.file_size, content="Some(54321)")
  guard sticker.mask_position is Some(m) else { fail("Expected mask_position") }
  inspect(m.point, content="eyes")
  inspect(m.y_shift, content="0.2")
}

///|
test "Sticker from fixed JSON custom_emoji with needs_repainting" {
  let json = @json.parse(
    #|{"file_id":"BQACAgIAAxkBAAK","file_unique_id":"AgADNAADTr2xSw","type":"custom_emoji","width":100,"height":100,"is_animated":true,"is_video":false,"custom_emoji_id":"5368324170671202286","needs_repainting":true}
  )
  let sticker : Sticker = @json.from_json(json)
  inspect(sticker.type_, content="custom_emoji")
  inspect(sticker.custom_emoji_id, content="Some(\"5368324170671202286\")")
  inspect(sticker.needs_repainting, content="Some(true)")
  inspect(sticker.emoji, content="None")
}

///|
test "StickerSet from fixed JSON without thumbnail" {
  let json = @json.parse(
    #|{"name":"some_pack","title":"Some Pack","sticker_type":"regular","stickers":[{"file_id":"s_fid1","file_unique_id":"s_uid1","type":"regular","width":512,"height":512,"is_animated":false,"is_video":false,"emoji":"U+1F600"},{"file_id":"s_fid2","file_unique_id":"s_uid2","type":"regular","width":512,"height":512,"is_animated":false,"is_video":false}]}
  )
  let set : StickerSet = @json.from_json(json)
  inspect(set.name, content="some_pack")
  inspect(set.title, content="Some Pack")
  inspect(set.sticker_type, content="regular")
  inspect(set.stickers.length(), content="2")
  inspect(set.stickers[0].emoji, content="Some(\"U+1F600\")")
  inspect(set.stickers[1].emoji, content="None")
  inspect(set.thumbnail, content="None")
}

///|
test "StickerSet from fixed JSON with thumbnail" {
  let json = @json.parse(
    #|{"name":"emoji_pack","title":"Emoji Pack","sticker_type":"custom_emoji","stickers":[{"file_id":"e_fid1","file_unique_id":"e_uid1","type":"custom_emoji","width":100,"height":100,"is_animated":true,"is_video":false}],"thumbnail":{"file_id":"thumb_fid","file_unique_id":"thumb_uid","width":64,"height":64}}
  )
  let set : StickerSet = @json.from_json(json)
  inspect(set.name, content="emoji_pack")
  inspect(set.sticker_type, content="custom_emoji")
  inspect(set.stickers.length(), content="1")
  guard set.thumbnail is Some(t) else { fail("Expected thumbnail") }
  inspect(t.file_id, content="thumb_fid")
  inspect(t.width, content="64")
}

///|
test "InputSticker from fixed JSON minimal" {
  let json = @json.parse(
    #|{"sticker":"CAACAgIAAxkBAAI...","format":"static","emoji_list":["U+1F600","U+1F601"]}
  )
  let input : InputSticker = @json.from_json(json)
  inspect(input.sticker, content="CAACAgIAAxkBAAI...")
  inspect(input.format, content="static")
  inspect(input.emoji_list.length(), content="2")
  inspect(input.emoji_list[0], content="U+1F600")
  inspect(input.mask_position, content="None")
  inspect(input.keywords, content="None")
}

///|
test "InputSticker from fixed JSON with mask and keywords" {
  let json = @json.parse(
    #|{"sticker":"https://example.com/mask.webp","format":"animated","emoji_list":["U+1F92A"],"mask_position":{"point":"chin","x_shift":0.1,"y_shift":0.4,"scale":0.8},"keywords":["silly","fun"]}
  )
  let input : InputSticker = @json.from_json(json)
  inspect(input.sticker, content="https://example.com/mask.webp")
  inspect(input.format, content="animated")
  inspect(input.emoji_list.length(), content="1")
  guard input.mask_position is Some(m) else { fail("Expected mask_position") }
  inspect(m.point, content="chin")
  inspect(m.x_shift, content="0.1")
  guard input.keywords is Some(kw) else { fail("Expected keywords") }
  inspect(kw.length(), content="2")
  inspect(kw[1], content="fun")
}
