///|
test "StickerPlaceholder JSON round-trip" {
  let sticker = StickerPlaceholder::new(
    file_id="abc123",
    file_unique_id="unique456",
    width=512,
    height=512,
  )
  let json = sticker.to_json()
  let parsed : StickerPlaceholder = @json.from_json(json)
  inspect(parsed.file_id, content="abc123")
  inspect(parsed.file_unique_id, content="unique456")
  inspect(parsed.width, content="512")
  inspect(parsed.height, content="512")
}

///|
test "Gift JSON round-trip with optional fields" {
  let sticker = StickerPlaceholder::new(
    file_id="sticker123",
    file_unique_id="unique789",
    width=256,
    height=256,
  )
  let gift = Gift::new(
    id="gift001",
    sticker~,
    star_count=100,
    total_count=1000,
    remaining_count=500,
  )
  let json = gift.to_json()
  let parsed : Gift = @json.from_json(json)
  inspect(parsed.id, content="gift001")
  inspect(parsed.star_count, content="100")
  inspect(parsed.total_count, content="Some(1000)")
  inspect(parsed.remaining_count, content="Some(500)")
}

///|
test "Gift JSON round-trip without optional fields" {
  let sticker = StickerPlaceholder::new(
    file_id="sticker456",
    file_unique_id="unique012",
    width=128,
    height=128,
  )
  let gift = Gift::new(id="gift002", sticker~, star_count=50)
  let json = gift.to_json()
  let parsed : Gift = @json.from_json(json)
  inspect(parsed.id, content="gift002")
  inspect(parsed.star_count, content="50")
  inspect(parsed.total_count, content="None")
  inspect(parsed.remaining_count, content="None")
}

///|
test "Gifts JSON round-trip" {
  let sticker = StickerPlaceholder::new(
    file_id="sticker789",
    file_unique_id="unique345",
    width=64,
    height=64,
  )
  let gift1 = Gift::new(id="gift003", sticker~, star_count=25)
  let gift2 = Gift::new(id="gift004", sticker~, star_count=75, total_count=500)
  let gifts = Gifts::new(gifts=[gift1, gift2])
  let json = gifts.to_json()
  let parsed : Gifts = @json.from_json(json)
  inspect(parsed.gifts.length(), content="2")
  inspect(parsed.gifts[0].id, content="gift003")
  inspect(parsed.gifts[1].id, content="gift004")
}

///|
test "AcceptedGiftTypes JSON round-trip" {
  let types = AcceptedGiftTypes::new(
    unlimited_gifts=true,
    limited_gifts=false,
    unique_gifts=true,
    premium_subscription=false,
  )
  let json = types.to_json()
  let parsed : AcceptedGiftTypes = @json.from_json(json)
  inspect(parsed.unlimited_gifts, content="true")
  inspect(parsed.limited_gifts, content="false")
  inspect(parsed.unique_gifts, content="true")
  inspect(parsed.premium_subscription, content="false")
}

///|
test "UniqueGiftColors JSON round-trip" {
  let colors = UniqueGiftColors::new(
    background_icon_color=16711680,
    text_color=16777215,
    hint_color=12345678,
    link_color=9876543,
    button_color=5555555,
    button_text_color=11111111,
  )
  let json = colors.to_json()
  let parsed : UniqueGiftColors = @json.from_json(json)
  inspect(parsed.background_icon_color, content="16711680")
  inspect(parsed.text_color, content="16777215")
  inspect(parsed.hint_color, content="12345678")
  inspect(parsed.link_color, content="9876543")
  inspect(parsed.button_color, content="5555555")
  inspect(parsed.button_text_color, content="11111111")
}

///|
test "GiftBackground JSON round-trip with fill" {
  let bg = GiftBackground::new(type_="fill", fill_color=255)
  let json = bg.to_json()
  let parsed : GiftBackground = @json.from_json(json)
  inspect(parsed.type_, content="fill")
  inspect(parsed.fill_color, content="Some(255)")
  inspect(parsed.gradient_top_color, content="None")
  inspect(parsed.gradient_bottom_color, content="None")
}

///|
test "GiftBackground JSON round-trip with gradient" {
  let bg = GiftBackground::new(
    type_="gradient",
    gradient_top_color=100,
    gradient_bottom_color=200,
  )
  let json = bg.to_json()
  let parsed : GiftBackground = @json.from_json(json)
  inspect(parsed.type_, content="gradient")
  inspect(parsed.fill_color, content="None")
  inspect(parsed.gradient_top_color, content="Some(100)")
  inspect(parsed.gradient_bottom_color, content="Some(200)")
}

///|
test "UniqueGiftInfo JSON round-trip" {
  let info = UniqueGiftInfo::new(
    gift_id="gift123",
    next_transfer_date=1703980800,
    last_resale_amount=500,
    origin="resale",
    is_from_blockchain=true,
  )
  let json = info.to_json()
  let parsed : UniqueGiftInfo = @json.from_json(json)
  inspect(parsed.gift_id, content="gift123")
  inspect(parsed.next_transfer_date, content="Some(1703980800)")
  inspect(parsed.last_resale_amount, content="Some(500)")
  inspect(
    parsed.origin,
    content=(
      #|Some("resale")
    ),
  )
  inspect(parsed.is_from_blockchain, content="Some(true)")
}

///|
test "UniqueGiftInfo JSON round-trip minimal" {
  let info = UniqueGiftInfo::new(gift_id="gift456")
  let json = info.to_json()
  let parsed : UniqueGiftInfo = @json.from_json(json)
  inspect(parsed.gift_id, content="gift456")
  inspect(parsed.next_transfer_date, content="None")
  inspect(parsed.last_resale_amount, content="None")
  inspect(parsed.origin, content="None")
  inspect(parsed.is_from_blockchain, content="None")
}

///|
test "StarBalance JSON round-trip" {
  let balance = StarBalance::new(balance=10000)
  let json = balance.to_json()
  let parsed : StarBalance = @json.from_json(json)
  inspect(parsed.balance, content="10000")
}

///|
test "Gift with all new fields JSON round-trip" {
  let sticker = StickerPlaceholder::new(
    file_id="sticker_full",
    file_unique_id="unique_full",
    width=512,
    height=512,
  )
  let chat = Chat::new(
    id=123456789,
    type_=ChatType::Channel,
    title="Test Channel",
  )
  let colors = UniqueGiftColors::new(
    background_icon_color=123456,
    text_color=234567,
    hint_color=345678,
    link_color=456789,
    button_color=567890,
    button_text_color=678901,
  )
  let bg = GiftBackground::new(
    type_="gradient",
    gradient_top_color=100,
    gradient_bottom_color=200,
  )
  let gift = Gift::new(
    id="gift_full",
    sticker~,
    star_count=150,
    total_count=500,
    remaining_count=250,
    publisher_chat=chat,
    colors~,
    background=bg,
    unique_gift_variant_count=5,
    unique_gift_number=3,
    gifts_from_channels=true,
    is_premium=false,
    has_colors=true,
  )
  let json = gift.to_json()
  let parsed : Gift = @json.from_json(json)
  inspect(parsed.id, content="gift_full")
  inspect(parsed.star_count, content="150")
  inspect(parsed.total_count, content="Some(500)")
  inspect(parsed.unique_gift_variant_count, content="Some(5)")
  inspect(parsed.unique_gift_number, content="Some(3)")
  inspect(parsed.gifts_from_channels, content="Some(true)")
  inspect(parsed.is_premium, content="Some(false)")
  inspect(parsed.has_colors, content="Some(true)")
}

///|
test "StickerPlaceholder from fixed JSON" {
  let json = @json.parse(
    (
      #|{"file_id":"CAACAgIAAxkBAAI","file_unique_id":"AgADXQADIyqpSw","width":512,"height":512}
    ),
  )
  let sp : StickerPlaceholder = @json.from_json(json)
  inspect(sp.file_id, content="CAACAgIAAxkBAAI")
  inspect(sp.file_unique_id, content="AgADXQADIyqpSw")
  inspect(sp.width, content="512")
  inspect(sp.height, content="512")
}

///|
test "Gift from fixed JSON minimal" {
  let json = @json.parse(
    (
      #|{"id":"gift_minimal_01","sticker":{"file_id":"StickerFileId","file_unique_id":"StickerUniqId","width":256,"height":256},"star_count":50}
    ),
  )
  let gift : Gift = @json.from_json(json)
  inspect(gift.id, content="gift_minimal_01")
  inspect(gift.sticker.file_id, content="StickerFileId")
  inspect(gift.star_count, content="50")
  inspect(gift.total_count, content="None")
  inspect(gift.remaining_count, content="None")
  inspect(gift.is_premium, content="None")
  inspect(gift.has_colors, content="None")
}

///|
test "Gift from fixed JSON with optional fields" {
  let json = @json.parse(
    (
      #|{"id":"gift_opt_02","sticker":{"file_id":"StickerFid2","file_unique_id":"StickerUid2","width":128,"height":128},"star_count":200,"total_count":1000,"remaining_count":750,"is_premium":true,"gifts_from_channels":false,"has_colors":true}
    ),
  )
  let gift : Gift = @json.from_json(json)
  inspect(gift.id, content="gift_opt_02")
  inspect(gift.star_count, content="200")
  inspect(gift.total_count, content="Some(1000)")
  inspect(gift.remaining_count, content="Some(750)")
  inspect(gift.is_premium, content="Some(true)")
  inspect(gift.gifts_from_channels, content="Some(false)")
  inspect(gift.has_colors, content="Some(true)")
  inspect(gift.publisher_chat, content="None")
}

///|
test "Gifts from fixed JSON" {
  let json = @json.parse(
    (
      #|{"gifts":[{"id":"g1","sticker":{"file_id":"fid1","file_unique_id":"uid1","width":64,"height":64},"star_count":10},{"id":"g2","sticker":{"file_id":"fid2","file_unique_id":"uid2","width":64,"height":64},"star_count":20,"total_count":500}]}
    ),
  )
  let gifts : Gifts = @json.from_json(json)
  inspect(gifts.gifts.length(), content="2")
  inspect(gifts.gifts[0].id, content="g1")
  inspect(gifts.gifts[0].star_count, content="10")
  inspect(gifts.gifts[1].id, content="g2")
  inspect(gifts.gifts[1].total_count, content="Some(500)")
}

///|
test "AcceptedGiftTypes from fixed JSON" {
  let json = @json.parse(
    (
      #|{"unlimited_gifts":true,"limited_gifts":false,"unique_gifts":true,"premium_subscription":false}
    ),
  )
  let types : AcceptedGiftTypes = @json.from_json(json)
  inspect(types.unlimited_gifts, content="true")
  inspect(types.limited_gifts, content="false")
  inspect(types.unique_gifts, content="true")
  inspect(types.premium_subscription, content="false")
}

///|
test "UniqueGiftInfo from fixed JSON with all fields" {
  let json = @json.parse(
    (
      #|{"gift_id":"unique_gift_xyz","next_transfer_date":1800000000,"last_resale_amount":1500,"origin":"purchase","is_from_blockchain":false}
    ),
  )
  let info : UniqueGiftInfo = @json.from_json(json)
  inspect(info.gift_id, content="unique_gift_xyz")
  inspect(info.next_transfer_date, content="Some(1800000000)")
  inspect(info.last_resale_amount, content="Some(1500)")
  inspect(info.origin, content="Some(\"purchase\")")
  inspect(info.is_from_blockchain, content="Some(false)")
}

///|
test "UniqueGiftInfo from fixed JSON minimal" {
  let json = @json.parse(
    (
      #|{"gift_id":"minimal_gift"}
    ),
  )
  let info : UniqueGiftInfo = @json.from_json(json)
  inspect(info.gift_id, content="minimal_gift")
  inspect(info.next_transfer_date, content="None")
  inspect(info.last_resale_amount, content="None")
  inspect(info.origin, content="None")
  inspect(info.is_from_blockchain, content="None")
}

///|
test "StarBalance from fixed JSON" {
  let json = @json.parse(
    (
      #|{"balance":5000}
    ),
  )
  let balance : StarBalance = @json.from_json(json)
  inspect(balance.balance, content="5000")
}
