///|
test "ChatMember Owner JSON round-trip" {
  let user = User::new(id=123L, is_bot=false, first_name="John")
  let chat_member : ChatMember = Owner(
    ChatMemberOwner::new(user~, is_anonymous=true, custom_title="Founder"),
  )
  let json = @json.to_json(chat_member)
  let parsed : ChatMember = @json.from_json(json)
  guard parsed is Owner(owner) else { fail("Expected Owner variant") }
  inspect(owner.user.id, content="123")
  inspect(owner.is_anonymous, content="true")
  inspect(owner.custom_title, content="Some(\"Founder\")")
}

///|
test "ChatMember Administrator JSON round-trip" {
  let user = User::new(id=456L, is_bot=false, first_name="Admin")
  let chat_member : ChatMember = Administrator(
    ChatMemberAdministrator::new(
      user~,
      can_be_edited=true,
      is_anonymous=false,
      can_manage_chat=true,
      can_delete_messages=true,
      can_manage_video_chats=true,
      can_restrict_members=true,
      can_promote_members=false,
      can_change_info=true,
      can_invite_users=true,
      can_post_stories=true,
      can_edit_stories=true,
      can_delete_stories=true,
      can_post_messages=true,
      can_pin_messages=true,
    ),
  )
  let json = @json.to_json(chat_member)
  let parsed : ChatMember = @json.from_json(json)
  guard parsed is Administrator(admin) else {
    fail("Expected Administrator variant")
  }
  inspect(admin.user.id, content="456")
  inspect(admin.can_be_edited, content="true")
  inspect(admin.can_post_messages, content="Some(true)")
  inspect(admin.can_edit_messages, content="None")
  inspect(admin.can_pin_messages, content="Some(true)")
}

///|
test "ChatMember Member JSON round-trip" {
  let user = User::new(id=789L, is_bot=false, first_name="Member")
  let chat_member : ChatMember = Member(ChatMemberMember::new(user~))
  let json = @json.to_json(chat_member)
  let parsed : ChatMember = @json.from_json(json)
  guard parsed is Member(m) else { fail("Expected Member variant") }
  inspect(m.user.id, content="789")
  inspect(m.until_date, content="None")
}

///|
test "ChatMember Member with until_date JSON round-trip" {
  let user = User::new(id=111L, is_bot=false, first_name="Subscriber")
  let chat_member : ChatMember = Member(
    ChatMemberMember::new(user~, until_date=1700000000),
  )
  let json = @json.to_json(chat_member)
  let parsed : ChatMember = @json.from_json(json)
  guard parsed is Member(m) else { fail("Expected Member variant") }
  inspect(m.until_date, content="Some(1700000000)")
}

///|
test "ChatMember Restricted JSON round-trip" {
  let user = User::new(id=222L, is_bot=false, first_name="Restricted")
  let chat_member : ChatMember = Restricted(
    ChatMemberRestricted::new(
      user~,
      is_member=true,
      can_send_messages=true,
      can_send_audios=false,
      can_send_documents=false,
      can_send_photos=true,
      can_send_videos=true,
      can_send_video_notes=false,
      can_send_voice_notes=false,
      can_send_polls=false,
      can_send_other_messages=false,
      can_add_web_page_previews=false,
      can_change_info=false,
      can_invite_users=false,
      can_pin_messages=false,
      can_manage_topics=false,
      until_date=0,
    ),
  )
  let json = @json.to_json(chat_member)
  let parsed : ChatMember = @json.from_json(json)
  guard parsed is Restricted(r) else { fail("Expected Restricted variant") }
  inspect(r.user.id, content="222")
  inspect(r.is_member, content="true")
  inspect(r.can_send_messages, content="true")
  inspect(r.can_send_audios, content="false")
  inspect(r.until_date, content="0")
}

///|
test "ChatMember Left JSON round-trip" {
  let user = User::new(id=333L, is_bot=false, first_name="LeftUser")
  let chat_member : ChatMember = Left(ChatMemberLeft::new(user~))
  let json = @json.to_json(chat_member)
  let parsed : ChatMember = @json.from_json(json)
  guard parsed is Left(l) else { fail("Expected Left variant") }
  inspect(l.user.id, content="333")
}

///|
test "ChatMember Banned JSON round-trip" {
  let user = User::new(id=444L, is_bot=false, first_name="Banned")
  let chat_member : ChatMember = Banned(
    ChatMemberBanned::new(user~, until_date=1800000000),
  )
  let json = @json.to_json(chat_member)
  let parsed : ChatMember = @json.from_json(json)
  guard parsed is Banned(b) else { fail("Expected Banned variant") }
  inspect(b.user.id, content="444")
  inspect(b.until_date, content="1800000000")
}

///|
test "ChatPermissions JSON round-trip" {
  let perms = ChatPermissions::new(
    can_send_messages=true,
    can_send_photos=true,
    can_send_videos=true,
    can_change_info=false,
  )
  let json = @json.to_json(perms)
  let parsed : ChatPermissions = @json.from_json(json)
  inspect(parsed.can_send_messages, content="Some(true)")
  inspect(parsed.can_send_photos, content="Some(true)")
  inspect(parsed.can_send_audios, content="None")
  inspect(parsed.can_change_info, content="Some(false)")
}

///|
test "ChatPermissions empty JSON round-trip" {
  let perms = ChatPermissions::new()
  let json = @json.to_json(perms)
  let parsed : ChatPermissions = @json.from_json(json)
  inspect(parsed.can_send_messages, content="None")
  inspect(parsed.can_manage_topics, content="None")
}

///|
test "ChatAdministratorRights JSON round-trip" {
  let rights = ChatAdministratorRights::new(
    is_anonymous=false,
    can_manage_chat=true,
    can_delete_messages=true,
    can_manage_video_chats=true,
    can_restrict_members=true,
    can_promote_members=true,
    can_change_info=true,
    can_invite_users=true,
    can_post_stories=true,
    can_edit_stories=true,
    can_delete_stories=true,
    can_post_messages=true,
    can_pin_messages=true,
  )
  let json = @json.to_json(rights)
  let parsed : ChatAdministratorRights = @json.from_json(json)
  inspect(parsed.is_anonymous, content="false")
  inspect(parsed.can_manage_chat, content="true")
  inspect(parsed.can_post_messages, content="Some(true)")
  inspect(parsed.can_edit_messages, content="None")
  inspect(parsed.can_pin_messages, content="Some(true)")
  inspect(parsed.can_manage_topics, content="None")
}

///|
test "ChatMember::Owner from fixed JSON" {
  let json = @json.parse(
    #|{"status":"creator","user":{"id":123,"is_bot":false,"first_name":"Admin"},"is_anonymous":false}
  )
  let member : ChatMember = @json.from_json(json)
  guard member is Owner(owner) else { fail("Expected Owner") }
  inspect(owner.user.id, content="123")
  inspect(owner.is_anonymous, content="false")
  inspect(owner.custom_title, content="None")
}

///|
test "ChatMember::Owner from fixed JSON with custom_title" {
  let json = @json.parse(
    #|{"status":"creator","user":{"id":777,"is_bot":false,"first_name":"Boss"},"is_anonymous":true,"custom_title":"Founder"}
  )
  let member : ChatMember = @json.from_json(json)
  guard member is Owner(owner) else { fail("Expected Owner") }
  inspect(owner.user.id, content="777")
  inspect(owner.is_anonymous, content="true")
  inspect(owner.custom_title, content="Some(\"Founder\")")
}

///|
test "ChatMember::Administrator from fixed JSON" {
  let json = @json.parse(
    #|{"status":"administrator","user":{"id":456,"is_bot":false,"first_name":"Mod"},"can_be_edited":false,"is_anonymous":false,"can_manage_chat":true,"can_delete_messages":true,"can_manage_video_chats":true,"can_restrict_members":true,"can_promote_members":false,"can_change_info":true,"can_invite_users":true,"can_post_stories":false,"can_edit_stories":false,"can_delete_stories":false,"can_pin_messages":true}
  )
  let member : ChatMember = @json.from_json(json)
  guard member is Administrator(admin) else { fail("Expected Administrator") }
  inspect(admin.user.id, content="456")
  inspect(admin.can_be_edited, content="false")
  inspect(admin.can_manage_chat, content="true")
  inspect(admin.can_pin_messages, content="Some(true)")
  inspect(admin.can_post_messages, content="None")
  inspect(admin.custom_title, content="None")
}

///|
test "ChatMember::Member from fixed JSON" {
  let json = @json.parse(
    #|{"status":"member","user":{"id":789,"is_bot":false,"first_name":"Regular"}}
  )
  let member : ChatMember = @json.from_json(json)
  guard member is Member(m) else { fail("Expected Member") }
  inspect(m.user.id, content="789")
  inspect(m.until_date, content="None")
}

///|
test "ChatMember::Member from fixed JSON with until_date" {
  let json = @json.parse(
    #|{"status":"member","user":{"id":999,"is_bot":false,"first_name":"Sub"},"until_date":1800000000}
  )
  let member : ChatMember = @json.from_json(json)
  guard member is Member(m) else { fail("Expected Member") }
  inspect(m.user.id, content="999")
  inspect(m.until_date, content="Some(1800000000)")
}

///|
test "ChatMember::Restricted from fixed JSON" {
  let json = @json.parse(
    #|{"status":"restricted","user":{"id":100,"is_bot":false,"first_name":"Restricted"},"is_member":true,"can_send_messages":false,"can_send_audios":false,"can_send_documents":false,"can_send_photos":false,"can_send_videos":false,"can_send_video_notes":false,"can_send_voice_notes":false,"can_send_polls":false,"can_send_other_messages":false,"can_add_web_page_previews":false,"can_change_info":false,"can_invite_users":false,"can_pin_messages":false,"can_manage_topics":false,"until_date":0}
  )
  let member : ChatMember = @json.from_json(json)
  guard member is Restricted(r) else { fail("Expected Restricted") }
  inspect(r.user.id, content="100")
  inspect(r.is_member, content="true")
  inspect(r.can_send_messages, content="false")
  inspect(r.until_date, content="0")
}

///|
test "ChatMember::Left from fixed JSON" {
  let json = @json.parse(
    #|{"status":"left","user":{"id":200,"is_bot":false,"first_name":"Departed"}}
  )
  let member : ChatMember = @json.from_json(json)
  guard member is Left(l) else { fail("Expected Left") }
  inspect(l.user.id, content="200")
  inspect(l.user.first_name, content="Departed")
}

///|
test "ChatMember::Banned from fixed JSON" {
  let json = @json.parse(
    #|{"status":"kicked","user":{"id":300,"is_bot":false,"first_name":"Banned"},"until_date":1700000000}
  )
  let member : ChatMember = @json.from_json(json)
  guard member is Banned(b) else { fail("Expected Banned") }
  inspect(b.user.id, content="300")
  inspect(b.until_date, content="1700000000")
}

///|
test "ChatPermissions from fixed JSON" {
  let json = @json.parse(
    #|{"can_send_messages":true,"can_send_photos":true,"can_send_videos":false,"can_change_info":false}
  )
  let perms : ChatPermissions = @json.from_json(json)
  inspect(perms.can_send_messages, content="Some(true)")
  inspect(perms.can_send_photos, content="Some(true)")
  inspect(perms.can_send_videos, content="Some(false)")
  inspect(perms.can_send_audios, content="None")
  inspect(perms.can_change_info, content="Some(false)")
}

///|
test "ChatAdministratorRights from fixed JSON" {
  let json = @json.parse(
    #|{"is_anonymous":false,"can_manage_chat":true,"can_delete_messages":true,"can_manage_video_chats":true,"can_restrict_members":false,"can_promote_members":false,"can_change_info":true,"can_invite_users":true,"can_post_stories":true,"can_edit_stories":true,"can_delete_stories":true,"can_post_messages":true,"can_manage_topics":false}
  )
  let rights : ChatAdministratorRights = @json.from_json(json)
  inspect(rights.is_anonymous, content="false")
  inspect(rights.can_manage_chat, content="true")
  inspect(rights.can_restrict_members, content="false")
  inspect(rights.can_post_messages, content="Some(true)")
  inspect(rights.can_edit_messages, content="None")
  inspect(rights.can_pin_messages, content="None")
  inspect(rights.can_manage_topics, content="Some(false)")
}
