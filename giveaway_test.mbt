///|
test "GiveawayCreated JSON round-trip" {
  let created = GiveawayCreated::new(prize_star_count=1000)
  let json = @json.to_json(created)
  let parsed : GiveawayCreated = @json.from_json(json)
  inspect(parsed.prize_star_count, content="Some(1000)")
}

///|
test "GiveawayCreated JSON round-trip without optional" {
  let created = GiveawayCreated::new()
  let json = @json.to_json(created)
  let parsed : GiveawayCreated = @json.from_json(json)
  inspect(parsed.prize_star_count, content="None")
}

///|
test "Giveaway JSON round-trip" {
  let chat = Chat::new(id=123L, type_=ChatType::Channel, title="Test Channel")
  let giveaway = Giveaway::new(
    chats=[chat],
    winners_selection_date=1700000000,
    winner_count=5,
    only_new_members=true,
    has_public_winners=true,
    prize_description="Premium subscription",
    country_codes=["US", "GB"],
    prize_star_count=500,
    premium_subscription_month_count=3,
  )
  let json = @json.to_json(giveaway)
  let parsed : Giveaway = @json.from_json(json)
  inspect(parsed.chats.length(), content="1")
  inspect(parsed.winners_selection_date, content="1700000000")
  inspect(parsed.winner_count, content="5")
  inspect(parsed.only_new_members, content="Some(true)")
  inspect(parsed.has_public_winners, content="Some(true)")
  inspect(parsed.prize_description, content="Some(\"Premium subscription\")")
  inspect(parsed.country_codes, content="Some([\"US\", \"GB\"])")
  inspect(parsed.prize_star_count, content="Some(500)")
  inspect(parsed.premium_subscription_month_count, content="Some(3)")
}

///|
test "Giveaway JSON round-trip minimal" {
  let chat = Chat::new(id=456L, type_=ChatType::Supergroup)
  let giveaway = Giveaway::new(
    chats=[chat],
    winners_selection_date=1700000000,
    winner_count=10,
  )
  let json = @json.to_json(giveaway)
  let parsed : Giveaway = @json.from_json(json)
  inspect(parsed.chats.length(), content="1")
  inspect(parsed.winner_count, content="10")
  inspect(parsed.only_new_members, content="None")
  inspect(parsed.country_codes, content="None")
}

///|
test "GiveawayWinners JSON round-trip" {
  let chat = Chat::new(id=789L, type_=ChatType::Channel, title="Giveaway Chat")
  let winner = User::new(id=111L, is_bot=false, first_name="Winner")
  let winners_obj = GiveawayWinners::new(
    chat~,
    giveaway_message_id=1001,
    winners_selection_date=1700000000,
    winner_count=3,
    winners=[winner],
    additional_chat_count=2,
    prize_star_count=100,
    premium_subscription_month_count=1,
    unclaimed_prize_count=1,
    only_new_members=true,
    was_refunded=false,
    prize_description="Monthly premium",
  )
  let json = @json.to_json(winners_obj)
  let parsed : GiveawayWinners = @json.from_json(json)
  inspect(parsed.chat.id, content="789")
  inspect(parsed.giveaway_message_id, content="1001")
  inspect(parsed.winners_selection_date, content="1700000000")
  inspect(parsed.winner_count, content="3")
  inspect(parsed.winners.length(), content="1")
  inspect(parsed.additional_chat_count, content="Some(2)")
  inspect(parsed.prize_star_count, content="Some(100)")
  inspect(parsed.premium_subscription_month_count, content="Some(1)")
  inspect(parsed.unclaimed_prize_count, content="Some(1)")
  inspect(parsed.only_new_members, content="Some(true)")
  inspect(parsed.was_refunded, content="Some(false)")
  inspect(parsed.prize_description, content="Some(\"Monthly premium\")")
}

///|
test "GiveawayWinners JSON round-trip minimal" {
  let chat = Chat::new(id=100L, type_=ChatType::Supergroup)
  let winner = User::new(id=200L, is_bot=false, first_name="Alice")
  let winners_obj = GiveawayWinners::new(
    chat~,
    giveaway_message_id=500,
    winners_selection_date=1700000000,
    winner_count=1,
    winners=[winner],
  )
  let json = @json.to_json(winners_obj)
  let parsed : GiveawayWinners = @json.from_json(json)
  inspect(parsed.winner_count, content="1")
  inspect(parsed.additional_chat_count, content="None")
  inspect(parsed.was_refunded, content="None")
}

///|
test "GiveawayCompleted JSON round-trip" {
  let chat = Chat::new(id=999L, type_=ChatType::Private)
  let msg = Message::new(message_id=123, date=1700000000, chat~, text="Win")
  let completed = GiveawayCompleted::new(
    winner_count=5,
    unclaimed_prize_count=2,
    giveaway_message=msg,
    is_star_giveaway=true,
  )
  let json = @json.to_json(completed)
  let parsed : GiveawayCompleted = @json.from_json(json)
  inspect(parsed.winner_count, content="5")
  inspect(parsed.unclaimed_prize_count, content="Some(2)")
  inspect(parsed.is_star_giveaway, content="Some(true)")
  guard parsed.giveaway_message is Some(m) else {
    fail("Expected giveaway_message")
  }
  inspect(m.message_id, content="123")
}

///|
test "GiveawayCompleted JSON round-trip minimal" {
  let completed = GiveawayCompleted::new(winner_count=10)
  let json = @json.to_json(completed)
  let parsed : GiveawayCompleted = @json.from_json(json)
  inspect(parsed.winner_count, content="10")
  inspect(parsed.unclaimed_prize_count, content="None")
  inspect(parsed.giveaway_message, content="None")
  inspect(parsed.is_star_giveaway, content="None")
}
