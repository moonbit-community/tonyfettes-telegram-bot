///|
test "PollOption JSON round-trip" {
  let option = PollOption::new(text="Option A", voter_count=10)
  let json = @json.to_json(option)
  let parsed : PollOption = @json.from_json(json)
  inspect(parsed.text, content="Option A")
  inspect(parsed.voter_count, content="10")
  inspect(parsed.text_entities, content="None")
}

///|
test "PollOption with text_entities JSON round-trip" {
  let entities : Array[MessageEntity] = [
    MessageEntity::new(type_="bold", offset=0, length=6),
  ]
  let option = PollOption::new(
    text="Option B",
    text_entities=entities,
    voter_count=5,
  )
  let json = @json.to_json(option)
  let parsed : PollOption = @json.from_json(json)
  inspect(parsed.text, content="Option B")
  inspect(parsed.voter_count, content="5")
  guard parsed.text_entities is Some(ents) else {
    fail("Expected text_entities to be Some")
  }
  inspect(ents.length(), content="1")
  inspect(ents[0].type_, content="bold")
}

///|
test "InputPollOption JSON round-trip" {
  let option = InputPollOption::new(text="Input Option")
  let json = @json.to_json(option)
  let parsed : InputPollOption = @json.from_json(json)
  inspect(parsed.text, content="Input Option")
  inspect(parsed.text_parse_mode, content="None")
  inspect(parsed.text_entities, content="None")
}

///|
test "InputPollOption with all fields JSON round-trip" {
  let entities : Array[MessageEntity] = [
    MessageEntity::new(type_="italic", offset=0, length=5),
  ]
  let option = InputPollOption::new(
    text="Styled Option",
    text_parse_mode="HTML",
    text_entities=entities,
  )
  let json = @json.to_json(option)
  let parsed : InputPollOption = @json.from_json(json)
  inspect(parsed.text, content="Styled Option")
  inspect(parsed.text_parse_mode, content="Some(\"HTML\")")
  guard parsed.text_entities is Some(ents) else {
    fail("Expected text_entities to be Some")
  }
  inspect(ents.length(), content="1")
}

///|
test "Poll JSON round-trip (regular poll)" {
  let options : Array[PollOption] = [
    PollOption::new(text="Yes", voter_count=10),
    PollOption::new(text="No", voter_count=5),
  ]
  let poll = Poll::new(
    id="poll123",
    question="Do you like MoonBit?",
    options~,
    total_voter_count=15,
    is_closed=false,
    is_anonymous=true,
    type_="regular",
    allows_multiple_answers=false,
  )
  let json = @json.to_json(poll)
  let parsed : Poll = @json.from_json(json)
  inspect(parsed.id, content="poll123")
  inspect(parsed.question, content="Do you like MoonBit?")
  inspect(parsed.options.length(), content="2")
  inspect(parsed.total_voter_count, content="15")
  inspect(parsed.is_closed, content="false")
  inspect(parsed.is_anonymous, content="true")
  inspect(parsed.type_, content="regular")
  inspect(parsed.allows_multiple_answers, content="false")
  inspect(parsed.correct_option_id, content="None")
  inspect(parsed.explanation, content="None")
}

///|
test "Poll JSON round-trip (quiz poll with all fields)" {
  let options : Array[PollOption] = [
    PollOption::new(text="Paris", voter_count=20),
    PollOption::new(text="London", voter_count=5),
    PollOption::new(text="Berlin", voter_count=3),
  ]
  let explanation_entities : Array[MessageEntity] = [
    MessageEntity::new(type_="bold", offset=0, length=5),
  ]
  let poll = Poll::new(
    id="quiz456",
    question="What is the capital of France?",
    options~,
    total_voter_count=28,
    is_closed=false,
    is_anonymous=false,
    type_="quiz",
    allows_multiple_answers=false,
    correct_option_id=0,
    explanation="Paris is the capital of France.",
    explanation_entities~,
    open_period=300,
    close_date=1700000000,
  )
  let json = @json.to_json(poll)
  let parsed : Poll = @json.from_json(json)
  inspect(parsed.id, content="quiz456")
  inspect(parsed.type_, content="quiz")
  inspect(parsed.correct_option_id, content="Some(0)")
  inspect(
    parsed.explanation,
    content="Some(\"Paris is the capital of France.\")",
  )
  guard parsed.explanation_entities is Some(ents) else {
    fail("Expected explanation_entities to be Some")
  }
  inspect(ents.length(), content="1")
  inspect(parsed.open_period, content="Some(300)")
  inspect(parsed.close_date, content="Some(1700000000)")
}

///|
test "Poll type field serializes as 'type'" {
  let options : Array[PollOption] = [PollOption::new(text="A", voter_count=0)]
  let poll = Poll::new(
    id="test",
    question="Test?",
    options~,
    total_voter_count=0,
    is_closed=false,
    is_anonymous=true,
    type_="quiz",
    allows_multiple_answers=false,
  )
  let json = @json.to_json(poll)
  guard json is Object(object) else { fail("Expected object") }
  guard object.get("type") is Some(String(type_val)) else {
    fail("Expected 'type' field in JSON")
  }
  inspect(type_val, content="quiz")
  // Ensure type_ is not serialized
  inspect(object.get("type_") is None, content="true")
}

///|
test "PollAnswer JSON round-trip (minimal)" {
  let answer = PollAnswer::new(poll_id="poll789", option_ids=[0, 1])
  let json = @json.to_json(answer)
  let parsed : PollAnswer = @json.from_json(json)
  inspect(parsed.poll_id, content="poll789")
  inspect(parsed.option_ids, content="[0, 1]")
  inspect(parsed.voter_chat, content="None")
  inspect(parsed.user, content="None")
}

///|
test "PollAnswer JSON round-trip (with user)" {
  let user = User::new(
    id=12345L,
    is_bot=false,
    first_name="John",
    last_name="Doe",
  )
  let answer = PollAnswer::new(poll_id="poll999", user~, option_ids=[2])
  let json = @json.to_json(answer)
  let parsed : PollAnswer = @json.from_json(json)
  inspect(parsed.poll_id, content="poll999")
  inspect(parsed.option_ids, content="[2]")
  guard parsed.user is Some(u) else { fail("Expected user to be Some") }
  inspect(u.id, content="12345")
  inspect(u.first_name, content="John")
}

///|
test "PollAnswer JSON round-trip (with voter_chat)" {
  let chat = Chat::new(
    id=67890L,
    type_=ChatType::Supergroup,
    title="Test Group",
  )
  let answer = PollAnswer::new(poll_id="poll000", voter_chat=chat, option_ids=[
    0,
  ])
  let json = @json.to_json(answer)
  let parsed : PollAnswer = @json.from_json(json)
  inspect(parsed.poll_id, content="poll000")
  guard parsed.voter_chat is Some(c) else {
    fail("Expected voter_chat to be Some")
  }
  inspect(c.id, content="67890")
  inspect(c.type_, content="Supergroup")
  inspect(c.title, content="Some(\"Test Group\")")
}

///|
test "PollOption from fixed JSON" {
  let json = @json.parse(
    #|{"text":"Option A","voter_count":42}
  )
  let opt : PollOption = @json.from_json(json)
  inspect(opt.text, content="Option A")
  inspect(opt.voter_count, content="42")
  inspect(opt.text_entities, content="None")
}

///|
test "PollOption from fixed JSON with text_entities" {
  let json = @json.parse(
    #|{"text":"Bold text","voter_count":5,"text_entities":[{"type":"bold","offset":0,"length":4}]}
  )
  let opt : PollOption = @json.from_json(json)
  inspect(opt.text, content="Bold text")
  inspect(opt.voter_count, content="5")
  guard opt.text_entities is Some(ents) else {
    fail("Expected text_entities to be Some")
  }
  inspect(ents.length(), content="1")
  inspect(ents[0].type_, content="bold")
  inspect(ents[0].offset, content="0")
  inspect(ents[0].length, content="4")
}

///|
test "InputPollOption from fixed JSON" {
  let json = @json.parse(
    #|{"text":"My option","text_parse_mode":"HTML"}
  )
  let opt : InputPollOption = @json.from_json(json)
  inspect(opt.text, content="My option")
  inspect(opt.text_parse_mode, content="Some(\"HTML\")")
  inspect(opt.text_entities, content="None")
}

///|
test "InputPollOption from fixed JSON minimal" {
  let json = @json.parse(
    #|{"text":"Simple option"}
  )
  let opt : InputPollOption = @json.from_json(json)
  inspect(opt.text, content="Simple option")
  inspect(opt.text_parse_mode, content="None")
  inspect(opt.text_entities, content="None")
}

///|
test "Poll from fixed JSON (regular)" {
  let json = @json.parse(
    #|{"id":"poll_abc","question":"Favorite color?","options":[{"text":"Red","voter_count":10},{"text":"Blue","voter_count":20}],"total_voter_count":30,"is_closed":false,"is_anonymous":true,"type":"regular","allows_multiple_answers":false}
  )
  let poll : Poll = @json.from_json(json)
  inspect(poll.id, content="poll_abc")
  inspect(poll.question, content="Favorite color?")
  inspect(poll.options.length(), content="2")
  inspect(poll.options[0].text, content="Red")
  inspect(poll.options[0].voter_count, content="10")
  inspect(poll.options[1].text, content="Blue")
  inspect(poll.options[1].voter_count, content="20")
  inspect(poll.total_voter_count, content="30")
  inspect(poll.is_closed, content="false")
  inspect(poll.is_anonymous, content="true")
  inspect(poll.type_, content="regular")
  inspect(poll.allows_multiple_answers, content="false")
  inspect(poll.correct_option_id, content="None")
  inspect(poll.explanation, content="None")
}

///|
test "Poll from fixed JSON (quiz with optional fields)" {
  let json = @json.parse(
    #|{"id":"quiz_xyz","question":"Capital of Japan?","options":[{"text":"Tokyo","voter_count":50},{"text":"Osaka","voter_count":5}],"total_voter_count":55,"is_closed":false,"is_anonymous":false,"type":"quiz","allows_multiple_answers":false,"correct_option_id":0,"explanation":"Tokyo is the capital.","open_period":600}
  )
  let poll : Poll = @json.from_json(json)
  inspect(poll.id, content="quiz_xyz")
  inspect(poll.question, content="Capital of Japan?")
  inspect(poll.type_, content="quiz")
  inspect(poll.correct_option_id, content="Some(0)")
  inspect(poll.explanation, content="Some(\"Tokyo is the capital.\")")
  inspect(poll.open_period, content="Some(600)")
  inspect(poll.close_date, content="None")
  inspect(poll.question_entities, content="None")
  inspect(poll.explanation_entities, content="None")
}

///|
test "PollAnswer from fixed JSON minimal" {
  let json = @json.parse(
    #|{"poll_id":"poll123","option_ids":[0,2]}
  )
  let answer : PollAnswer = @json.from_json(json)
  inspect(answer.poll_id, content="poll123")
  inspect(answer.option_ids, content="[0, 2]")
  inspect(answer.voter_chat, content="None")
  inspect(answer.user, content="None")
}

///|
test "PollAnswer from fixed JSON with user" {
  let json = @json.parse(
    #|{"poll_id":"poll456","option_ids":[1],"user":{"id":99887766,"is_bot":false,"first_name":"Alice","username":"alice99"}}
  )
  let answer : PollAnswer = @json.from_json(json)
  inspect(answer.poll_id, content="poll456")
  inspect(answer.option_ids, content="[1]")
  guard answer.user is Some(u) else { fail("Expected user to be Some") }
  inspect(u.id, content="99887766")
  inspect(u.first_name, content="Alice")
  inspect(u.username, content="Some(\"alice99\")")
  inspect(answer.voter_chat, content="None")
}
