///|
test "GiveawayCreated JSON round-trip" {
  let created = GiveawayCreated::new(prize_star_count=1000)
  let json = created.to_json()
  let parsed : GiveawayCreated = @json.from_json(json)
  inspect(parsed.prize_star_count, content="Some(1000)")
}

///|
test "GiveawayCreated JSON round-trip without optional" {
  let created = GiveawayCreated::new()
  let json = created.to_json()
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
  let json = giveaway.to_json()
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
  let json = giveaway.to_json()
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
  let json = winners_obj.to_json()
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
  let json = winners_obj.to_json()
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
  let json = completed.to_json()
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
  let json = completed.to_json()
  let parsed : GiveawayCompleted = @json.from_json(json)
  inspect(parsed.winner_count, content="10")
  inspect(parsed.unclaimed_prize_count, content="None")
  inspect(parsed.giveaway_message, content="None")
  inspect(parsed.is_star_giveaway, content="None")
}

///|
test "GiveawayCreated from fixed JSON with prize_star_count" {
  let json = @json.parse(
    (
      #|{"prize_star_count":500}
    ),
  )
  let created : GiveawayCreated = @json.from_json(json)
  inspect(created.prize_star_count, content="Some(500)")
}

///|
test "GiveawayCreated from fixed JSON without prize_star_count" {
  let json = @json.parse(
    (
      #|{}
    ),
  )
  let created : GiveawayCreated = @json.from_json(json)
  inspect(created.prize_star_count, content="None")
}

///|
test "Giveaway from fixed JSON minimal" {
  let json = @json.parse(
    (
      #|{"chats":[{"id":123456,"type":"channel","title":"My Channel"}],"winners_selection_date":1750000000,"winner_count":3}
    ),
  )
  let giveaway : Giveaway = @json.from_json(json)
  inspect(giveaway.chats.length(), content="1")
  inspect(giveaway.chats[0].id, content="123456")
  inspect(giveaway.winners_selection_date, content="1750000000")
  inspect(giveaway.winner_count, content="3")
  inspect(giveaway.only_new_members, content="None")
  inspect(giveaway.prize_description, content="None")
  inspect(giveaway.country_codes, content="None")
  inspect(giveaway.prize_star_count, content="None")
}

///|
test "Giveaway from fixed JSON with all optional fields" {
  let json = @json.parse(
    (
      #|{"chats":[{"id":777888,"type":"supergroup"}],"winners_selection_date":1760000000,"winner_count":10,"only_new_members":true,"has_public_winners":false,"prize_description":"1 month premium","country_codes":["US","CA","GB"],"prize_star_count":250,"premium_subscription_month_count":1}
    ),
  )
  let giveaway : Giveaway = @json.from_json(json)
  inspect(giveaway.winner_count, content="10")
  inspect(giveaway.only_new_members, content="Some(true)")
  inspect(giveaway.has_public_winners, content="Some(false)")
  inspect(giveaway.prize_description, content="Some(\"1 month premium\")")
  inspect(giveaway.prize_star_count, content="Some(250)")
  inspect(giveaway.premium_subscription_month_count, content="Some(1)")
  guard giveaway.country_codes is Some(codes) else {
    fail("Expected country_codes")
  }
  inspect(codes.length(), content="3")
  inspect(codes[0], content="US")
}

///|
test "GiveawayWinners from fixed JSON minimal" {
  let json = @json.parse(
    (
      #|{"chat":{"id":555444,"type":"channel"},"giveaway_message_id":2001,"winners_selection_date":1750000000,"winner_count":2,"winners":[{"id":100001,"is_bot":false,"first_name":"Tom"},{"id":100002,"is_bot":false,"first_name":"Jerry"}]}
    ),
  )
  let winners : GiveawayWinners = @json.from_json(json)
  inspect(winners.chat.id, content="555444")
  inspect(winners.giveaway_message_id, content="2001")
  inspect(winners.winner_count, content="2")
  inspect(winners.winners.length(), content="2")
  inspect(winners.winners[0].first_name, content="Tom")
  inspect(winners.winners[1].first_name, content="Jerry")
  inspect(winners.additional_chat_count, content="None")
  inspect(winners.prize_description, content="None")
}

///|
test "GiveawayWinners from fixed JSON with optional fields" {
  let json = @json.parse(
    (
      #|{"chat":{"id":999111,"type":"channel","title":"Big Giveaway"},"giveaway_message_id":3001,"winners_selection_date":1760000000,"winner_count":5,"winners":[{"id":200001,"is_bot":false,"first_name":"Alice"}],"additional_chat_count":1,"prize_star_count":1000,"unclaimed_prize_count":2,"only_new_members":true,"was_refunded":false,"prize_description":"Special prize"}
    ),
  )
  let winners : GiveawayWinners = @json.from_json(json)
  inspect(winners.chat.title, content="Some(\"Big Giveaway\")")
  inspect(winners.additional_chat_count, content="Some(1)")
  inspect(winners.prize_star_count, content="Some(1000)")
  inspect(winners.unclaimed_prize_count, content="Some(2)")
  inspect(winners.only_new_members, content="Some(true)")
  inspect(winners.was_refunded, content="Some(false)")
  inspect(winners.prize_description, content="Some(\"Special prize\")")
}

///|
test "GiveawayCompleted from fixed JSON with optional fields" {
  let json = @json.parse(
    (
      #|{"winner_count":7,"unclaimed_prize_count":1,"is_star_giveaway":true,"giveaway_message":{"message_id":500,"date":1750000000,"chat":{"id":888777,"type":"channel"}}}
    ),
  )
  let completed : GiveawayCompleted = @json.from_json(json)
  inspect(completed.winner_count, content="7")
  inspect(completed.unclaimed_prize_count, content="Some(1)")
  inspect(completed.is_star_giveaway, content="Some(true)")
  guard completed.giveaway_message is Some(m) else {
    fail("Expected giveaway_message")
  }
  inspect(m.message_id, content="500")
  inspect(m.chat.id, content="888777")
}

///|
test "GiveawayCompleted from fixed JSON minimal" {
  let json = @json.parse(
    (
      #|{"winner_count":15}
    ),
  )
  let completed : GiveawayCompleted = @json.from_json(json)
  inspect(completed.winner_count, content="15")
  inspect(completed.unclaimed_prize_count, content="None")
  inspect(completed.giveaway_message, content="None")
  inspect(completed.is_star_giveaway, content="None")
}
