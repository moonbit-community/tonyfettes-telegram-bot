///|
test "Contact JSON round-trip" {
  let contact = Contact::new(
    phone_number="+1234567890",
    first_name="John",
    last_name="Doe",
    user_id=123456789L,
    vcard="BEGIN:VCARD\nVERSION:3.0\nFN:John Doe\nEND:VCARD",
  )
  let json = contact.to_json()
  let parsed : Contact = @json.from_json(json)
  inspect(parsed.phone_number, content="+1234567890")
  inspect(parsed.first_name, content="John")
  inspect(parsed.last_name, content="Some(\"Doe\")")
  inspect(parsed.user_id, content="Some(123456789)")
  inspect(
    parsed.vcard,
    content="Some(\"BEGIN:VCARD\\nVERSION:3.0\\nFN:John Doe\\nEND:VCARD\")",
  )
}

///|
test "Contact JSON minimal" {
  let contact = Contact::new(phone_number="+9876543210", first_name="Jane")
  let json = contact.to_json()
  let parsed : Contact = @json.from_json(json)
  inspect(parsed.phone_number, content="+9876543210")
  inspect(parsed.first_name, content="Jane")
  inspect(parsed.last_name, content="None")
  inspect(parsed.user_id, content="None")
  inspect(parsed.vcard, content="None")
}

///|
test "Contact from fixed JSON" {
  let json = @json.parse(
    (
      #|{"phone_number":"+1234567890","first_name":"John","last_name":"Doe","user_id":123456789}
    ),
  )
  let contact : Contact = @json.from_json(json)
  inspect(contact.phone_number, content="+1234567890")
  inspect(contact.first_name, content="John")
  inspect(contact.last_name, content="Some(\"Doe\")")
  inspect(contact.user_id, content="Some(123456789)")
  inspect(contact.vcard, content="None")
}

///|
test "Contact from fixed JSON minimal" {
  let json = @json.parse(
    (
      #|{"phone_number":"+9876543210","first_name":"Jane"}
    ),
  )
  let contact : Contact = @json.from_json(json)
  inspect(contact.phone_number, content="+9876543210")
  inspect(contact.first_name, content="Jane")
  inspect(contact.last_name, content="None")
  inspect(contact.user_id, content="None")
  inspect(contact.vcard, content="None")
}
