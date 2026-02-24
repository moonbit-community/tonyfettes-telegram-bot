///|
test "GiftInfo JSON round-trip" {
  let sticker = StickerPlaceholder::new(
    file_id="abc123",
    file_unique_id="unique123",
    width=512,
    height=512,
  )
  let gift = Gift::new(id="gift_id_123", sticker~, star_count=100)
  let original = GiftInfo::new(gift~)
  let json = @json.to_json(original)
  let decoded : GiftInfo = @json.from_json(json)
  inspect(decoded.gift.id, content="gift_id_123")
  inspect(decoded.gift.star_count, content="100")
  inspect(decoded.from, content="None")
}

///|
test "GiftInfo ToJson and FromJson with user" {
  let sticker = StickerPlaceholder::new(
    file_id="xyz789",
    file_unique_id="unique789",
    width=256,
    height=256,
  )
  let gift = Gift::new(
    id="gift_id_456",
    sticker~,
    star_count=500,
    total_count=1000,
    remaining_count=500,
  )
  let user = User::new(id=123456789L, is_bot=false, first_name="John")
  let gift_info = GiftInfo::new(gift~, from=user)
  let json = @json.to_json(gift_info)
  let reconstructed : GiftInfo = @json.from_json(json)
  inspect(reconstructed.gift.id, content="gift_id_456")
  inspect(reconstructed.gift.star_count, content="500")
  inspect(reconstructed.from is Some(_), content="true")
}

///|
test "GiftInfo from fixed JSON without from" {
  let json = @json.parse(
    (
      #|{"gift":{"id":"fixed_gift_001","sticker":{"file_id":"FixedStickerFid","file_unique_id":"FixedStickerUid","width":512,"height":512},"star_count":75}}
    ),
  )
  let info : GiftInfo = @json.from_json(json)
  inspect(info.gift.id, content="fixed_gift_001")
  inspect(info.gift.sticker.file_id, content="FixedStickerFid")
  inspect(info.gift.star_count, content="75")
  inspect(info.from, content="None")
}

///|
test "GiftInfo from fixed JSON with from user" {
  let json = @json.parse(
    (
      #|{"gift":{"id":"fixed_gift_002","sticker":{"file_id":"StickerFid002","file_unique_id":"StickerUid002","width":256,"height":256},"star_count":300,"total_count":500},"from":{"id":987654321,"is_bot":false,"first_name":"Carol","last_name":"Smith"}}
    ),
  )
  let info : GiftInfo = @json.from_json(json)
  inspect(info.gift.id, content="fixed_gift_002")
  inspect(info.gift.star_count, content="300")
  inspect(info.gift.total_count, content="Some(500)")
  guard info.from is Some(u) else { fail("Expected from user") }
  inspect(u.id, content="987654321")
  inspect(u.first_name, content="Carol")
  inspect(u.last_name, content="Some(\"Smith\")")
}
