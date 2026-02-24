///|
/// Represents a chat member that owns the chat and has all administrator privileges.
pub struct ChatMemberOwner {
  user : User
  is_anonymous : Bool
  custom_title : String?
} derive(Show, Eq)

///|
/// Creates a new [ChatMemberOwner].
pub fn ChatMemberOwner::new(
  user~ : User,
  is_anonymous~ : Bool,
  custom_title? : String,
) -> ChatMemberOwner {
  { user, is_anonymous, custom_title }
}

///|
/// Represents a chat member that has some additional privileges.
pub struct ChatMemberAdministrator {
  user : User
  can_be_edited : Bool
  is_anonymous : Bool
  can_manage_chat : Bool
  can_delete_messages : Bool
  can_manage_video_chats : Bool
  can_restrict_members : Bool
  can_promote_members : Bool
  can_change_info : Bool
  can_invite_users : Bool
  can_post_stories : Bool
  can_edit_stories : Bool
  can_delete_stories : Bool
  can_post_messages : Bool?
  can_edit_messages : Bool?
  can_pin_messages : Bool?
  can_manage_topics : Bool?
  custom_title : String?
} derive(Show, Eq)

///|
/// Creates a new [ChatMemberAdministrator].
pub fn ChatMemberAdministrator::new(
  user~ : User,
  can_be_edited~ : Bool,
  is_anonymous~ : Bool,
  can_manage_chat~ : Bool,
  can_delete_messages~ : Bool,
  can_manage_video_chats~ : Bool,
  can_restrict_members~ : Bool,
  can_promote_members~ : Bool,
  can_change_info~ : Bool,
  can_invite_users~ : Bool,
  can_post_stories~ : Bool,
  can_edit_stories~ : Bool,
  can_delete_stories~ : Bool,
  can_post_messages? : Bool,
  can_edit_messages? : Bool,
  can_pin_messages? : Bool,
  can_manage_topics? : Bool,
  custom_title? : String,
) -> ChatMemberAdministrator {
  {
    user,
    can_be_edited,
    is_anonymous,
    can_manage_chat,
    can_delete_messages,
    can_manage_video_chats,
    can_restrict_members,
    can_promote_members,
    can_change_info,
    can_invite_users,
    can_post_stories,
    can_edit_stories,
    can_delete_stories,
    can_post_messages,
    can_edit_messages,
    can_pin_messages,
    can_manage_topics,
    custom_title,
  }
}

///|
/// Represents a chat member that has no additional privileges or restrictions.
pub struct ChatMemberMember {
  user : User
  until_date : Int?
} derive(Show, Eq)

///|
/// Creates a new [ChatMemberMember].
pub fn ChatMemberMember::new(
  user~ : User,
  until_date? : Int,
) -> ChatMemberMember {
  { user, until_date }
}

///|
/// Represents a chat member that is under certain restrictions in the chat. Supergroups only.
pub struct ChatMemberRestricted {
  user : User
  is_member : Bool
  can_send_messages : Bool
  can_send_audios : Bool
  can_send_documents : Bool
  can_send_photos : Bool
  can_send_videos : Bool
  can_send_video_notes : Bool
  can_send_voice_notes : Bool
  can_send_polls : Bool
  can_send_other_messages : Bool
  can_add_web_page_previews : Bool
  can_change_info : Bool
  can_invite_users : Bool
  can_pin_messages : Bool
  can_manage_topics : Bool
  until_date : Int
} derive(Show, Eq)

///|
/// Creates a new [ChatMemberRestricted].
pub fn ChatMemberRestricted::new(
  user~ : User,
  is_member~ : Bool,
  can_send_messages~ : Bool,
  can_send_audios~ : Bool,
  can_send_documents~ : Bool,
  can_send_photos~ : Bool,
  can_send_videos~ : Bool,
  can_send_video_notes~ : Bool,
  can_send_voice_notes~ : Bool,
  can_send_polls~ : Bool,
  can_send_other_messages~ : Bool,
  can_add_web_page_previews~ : Bool,
  can_change_info~ : Bool,
  can_invite_users~ : Bool,
  can_pin_messages~ : Bool,
  can_manage_topics~ : Bool,
  until_date~ : Int,
) -> ChatMemberRestricted {
  {
    user,
    is_member,
    can_send_messages,
    can_send_audios,
    can_send_documents,
    can_send_photos,
    can_send_videos,
    can_send_video_notes,
    can_send_voice_notes,
    can_send_polls,
    can_send_other_messages,
    can_add_web_page_previews,
    can_change_info,
    can_invite_users,
    can_pin_messages,
    can_manage_topics,
    until_date,
  }
}

///|
/// Represents a chat member that isn't currently a member of the chat but may join it themselves.
pub struct ChatMemberLeft {
  user : User
} derive(Show, Eq)

///|
/// Creates a new [ChatMemberLeft].
pub fn ChatMemberLeft::new(user~ : User) -> ChatMemberLeft {
  { user, }
}

///|
/// Represents a chat member that was banned in the chat and can't return to the
/// chat or view chat messages.
pub struct ChatMemberBanned {
  user : User
  until_date : Int
} derive(Show, Eq)

///|
/// Creates a new [ChatMemberBanned].
pub fn ChatMemberBanned::new(
  user~ : User,
  until_date~ : Int,
) -> ChatMemberBanned {
  { user, until_date }
}

///|
/// This object contains information about one member of a chat.
pub(all) enum ChatMember {
  Owner(ChatMemberOwner)
  Administrator(ChatMemberAdministrator)
  Member(ChatMemberMember)
  Restricted(ChatMemberRestricted)
  Left(ChatMemberLeft)
  Banned(ChatMemberBanned)
} derive(Show, Eq)

///|
pub impl ToJson for ChatMember with to_json(self) {
  match self {
    Owner(v) => {
      let object : Map[String, Json] = {
        "status": "creator".to_json(),
        "user": v.user.to_json(),
        "is_anonymous": v.is_anonymous.to_json(),
      }
      if v.custom_title is Some(t) {
        object["custom_title"] = t.to_json()
      }
      object.to_json()
    }
    Administrator(v) => {
      let object : Map[String, Json] = {
        "status": "administrator".to_json(),
        "user": v.user.to_json(),
        "can_be_edited": v.can_be_edited.to_json(),
        "is_anonymous": v.is_anonymous.to_json(),
        "can_manage_chat": v.can_manage_chat.to_json(),
        "can_delete_messages": v.can_delete_messages.to_json(),
        "can_manage_video_chats": v.can_manage_video_chats.to_json(),
        "can_restrict_members": v.can_restrict_members.to_json(),
        "can_promote_members": v.can_promote_members.to_json(),
        "can_change_info": v.can_change_info.to_json(),
        "can_invite_users": v.can_invite_users.to_json(),
        "can_post_stories": v.can_post_stories.to_json(),
        "can_edit_stories": v.can_edit_stories.to_json(),
        "can_delete_stories": v.can_delete_stories.to_json(),
      }
      if v.can_post_messages is Some(x) {
        object["can_post_messages"] = x.to_json()
      }
      if v.can_edit_messages is Some(x) {
        object["can_edit_messages"] = x.to_json()
      }
      if v.can_pin_messages is Some(x) {
        object["can_pin_messages"] = x.to_json()
      }
      if v.can_manage_topics is Some(x) {
        object["can_manage_topics"] = x.to_json()
      }
      if v.custom_title is Some(t) {
        object["custom_title"] = t.to_json()
      }
      object.to_json()
    }
    Member(v) => {
      let object : Map[String, Json] = {
        "status": "member".to_json(),
        "user": v.user.to_json(),
      }
      if v.until_date is Some(d) {
        object["until_date"] = d.to_json()
      }
      object.to_json()
    }
    Restricted(v) => {
      let object : Map[String, Json] = {
        "status": "restricted".to_json(),
        "user": v.user.to_json(),
        "is_member": v.is_member.to_json(),
        "can_send_messages": v.can_send_messages.to_json(),
        "can_send_audios": v.can_send_audios.to_json(),
        "can_send_documents": v.can_send_documents.to_json(),
        "can_send_photos": v.can_send_photos.to_json(),
        "can_send_videos": v.can_send_videos.to_json(),
        "can_send_video_notes": v.can_send_video_notes.to_json(),
        "can_send_voice_notes": v.can_send_voice_notes.to_json(),
        "can_send_polls": v.can_send_polls.to_json(),
        "can_send_other_messages": v.can_send_other_messages.to_json(),
        "can_add_web_page_previews": v.can_add_web_page_previews.to_json(),
        "can_change_info": v.can_change_info.to_json(),
        "can_invite_users": v.can_invite_users.to_json(),
        "can_pin_messages": v.can_pin_messages.to_json(),
        "can_manage_topics": v.can_manage_topics.to_json(),
        "until_date": v.until_date.to_json(),
      }
      object.to_json()
    }
    Left(v) => {
      let object : Map[String, Json] = {
        "status": "left".to_json(),
        "user": v.user.to_json(),
      }
      object.to_json()
    }
    Banned(v) => {
      let object : Map[String, Json] = {
        "status": "kicked".to_json(),
        "user": v.user.to_json(),
        "until_date": v.until_date.to_json(),
      }
      object.to_json()
    }
  }
}

///|
pub impl @json.FromJson for ChatMember with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for ChatMember"))
  }
  guard object["status"] is String(status) else {
    raise @json.JsonDecodeError((path, "Expected status field"))
  }
  match status {
    "creator" => {
      let user : User = @json.from_json(object["user"], path~)
      let is_anonymous : Bool = @json.from_json(object["is_anonymous"], path~)
      let custom_title : String? = if object.get("custom_title") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Owner(ChatMemberOwner::new(user~, is_anonymous~, custom_title?))
    }
    "administrator" => {
      let user : User = @json.from_json(object["user"], path~)
      let can_be_edited : Bool = @json.from_json(object["can_be_edited"], path~)
      let is_anonymous : Bool = @json.from_json(object["is_anonymous"], path~)
      let can_manage_chat : Bool = @json.from_json(
        object["can_manage_chat"],
        path~,
      )
      let can_delete_messages : Bool = @json.from_json(
        object["can_delete_messages"],
        path~,
      )
      let can_manage_video_chats : Bool = @json.from_json(
        object["can_manage_video_chats"],
        path~,
      )
      let can_restrict_members : Bool = @json.from_json(
        object["can_restrict_members"],
        path~,
      )
      let can_promote_members : Bool = @json.from_json(
        object["can_promote_members"],
        path~,
      )
      let can_change_info : Bool = @json.from_json(
        object["can_change_info"],
        path~,
      )
      let can_invite_users : Bool = @json.from_json(
        object["can_invite_users"],
        path~,
      )
      let can_post_stories : Bool = @json.from_json(
        object["can_post_stories"],
        path~,
      )
      let can_edit_stories : Bool = @json.from_json(
        object["can_edit_stories"],
        path~,
      )
      let can_delete_stories : Bool = @json.from_json(
        object["can_delete_stories"],
        path~,
      )
      let can_post_messages : Bool? = if object.get("can_post_messages")
        is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let can_edit_messages : Bool? = if object.get("can_edit_messages")
        is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let can_pin_messages : Bool? = if object.get("can_pin_messages")
        is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let can_manage_topics : Bool? = if object.get("can_manage_topics")
        is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let custom_title : String? = if object.get("custom_title") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Administrator(
        ChatMemberAdministrator::new(
          user~,
          can_be_edited~,
          is_anonymous~,
          can_manage_chat~,
          can_delete_messages~,
          can_manage_video_chats~,
          can_restrict_members~,
          can_promote_members~,
          can_change_info~,
          can_invite_users~,
          can_post_stories~,
          can_edit_stories~,
          can_delete_stories~,
          can_post_messages?,
          can_edit_messages?,
          can_pin_messages?,
          can_manage_topics?,
          custom_title?,
        ),
      )
    }
    "member" => {
      let user : User = @json.from_json(object["user"], path~)
      let until_date : Int? = if object.get("until_date") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Member(ChatMemberMember::new(user~, until_date?))
    }
    "restricted" => {
      let user : User = @json.from_json(object["user"], path~)
      let is_member : Bool = @json.from_json(object["is_member"], path~)
      let can_send_messages : Bool = @json.from_json(
        object["can_send_messages"],
        path~,
      )
      let can_send_audios : Bool = @json.from_json(
        object["can_send_audios"],
        path~,
      )
      let can_send_documents : Bool = @json.from_json(
        object["can_send_documents"],
        path~,
      )
      let can_send_photos : Bool = @json.from_json(
        object["can_send_photos"],
        path~,
      )
      let can_send_videos : Bool = @json.from_json(
        object["can_send_videos"],
        path~,
      )
      let can_send_video_notes : Bool = @json.from_json(
        object["can_send_video_notes"],
        path~,
      )
      let can_send_voice_notes : Bool = @json.from_json(
        object["can_send_voice_notes"],
        path~,
      )
      let can_send_polls : Bool = @json.from_json(
        object["can_send_polls"],
        path~,
      )
      let can_send_other_messages : Bool = @json.from_json(
        object["can_send_other_messages"],
        path~,
      )
      let can_add_web_page_previews : Bool = @json.from_json(
        object["can_add_web_page_previews"],
        path~,
      )
      let can_change_info : Bool = @json.from_json(
        object["can_change_info"],
        path~,
      )
      let can_invite_users : Bool = @json.from_json(
        object["can_invite_users"],
        path~,
      )
      let can_pin_messages : Bool = @json.from_json(
        object["can_pin_messages"],
        path~,
      )
      let can_manage_topics : Bool = @json.from_json(
        object["can_manage_topics"],
        path~,
      )
      let until_date : Int = @json.from_json(object["until_date"], path~)
      Restricted(
        ChatMemberRestricted::new(
          user~,
          is_member~,
          can_send_messages~,
          can_send_audios~,
          can_send_documents~,
          can_send_photos~,
          can_send_videos~,
          can_send_video_notes~,
          can_send_voice_notes~,
          can_send_polls~,
          can_send_other_messages~,
          can_add_web_page_previews~,
          can_change_info~,
          can_invite_users~,
          can_pin_messages~,
          can_manage_topics~,
          until_date~,
        ),
      )
    }
    "left" => {
      let user : User = @json.from_json(object["user"], path~)
      Left(ChatMemberLeft::new(user~))
    }
    "kicked" => {
      let user : User = @json.from_json(object["user"], path~)
      let until_date : Int = @json.from_json(object["until_date"], path~)
      Banned(ChatMemberBanned::new(user~, until_date~))
    }
    _ =>
      raise @json.JsonDecodeError(
        (path, "Unknown ChatMember status: " + status),
      )
  }
}

///|
/// Describes actions that a non-administrator user is allowed to take in a chat.
pub struct ChatPermissions {
  can_send_messages : Bool?
  can_send_audios : Bool?
  can_send_documents : Bool?
  can_send_photos : Bool?
  can_send_videos : Bool?
  can_send_video_notes : Bool?
  can_send_voice_notes : Bool?
  can_send_polls : Bool?
  can_send_other_messages : Bool?
  can_add_web_page_previews : Bool?
  can_change_info : Bool?
  can_invite_users : Bool?
  can_pin_messages : Bool?
  can_manage_topics : Bool?
} derive(Show, Eq)

///|
/// Creates a new [ChatPermissions].
pub fn ChatPermissions::new(
  can_send_messages? : Bool,
  can_send_audios? : Bool,
  can_send_documents? : Bool,
  can_send_photos? : Bool,
  can_send_videos? : Bool,
  can_send_video_notes? : Bool,
  can_send_voice_notes? : Bool,
  can_send_polls? : Bool,
  can_send_other_messages? : Bool,
  can_add_web_page_previews? : Bool,
  can_change_info? : Bool,
  can_invite_users? : Bool,
  can_pin_messages? : Bool,
  can_manage_topics? : Bool,
) -> ChatPermissions {
  {
    can_send_messages,
    can_send_audios,
    can_send_documents,
    can_send_photos,
    can_send_videos,
    can_send_video_notes,
    can_send_voice_notes,
    can_send_polls,
    can_send_other_messages,
    can_add_web_page_previews,
    can_change_info,
    can_invite_users,
    can_pin_messages,
    can_manage_topics,
  }
}

///|
pub impl ToJson for ChatPermissions with to_json(self) {
  let object : Map[String, Json] = {}
  if self.can_send_messages is Some(v) {
    object["can_send_messages"] = v.to_json()
  }
  if self.can_send_audios is Some(v) {
    object["can_send_audios"] = v.to_json()
  }
  if self.can_send_documents is Some(v) {
    object["can_send_documents"] = v.to_json()
  }
  if self.can_send_photos is Some(v) {
    object["can_send_photos"] = v.to_json()
  }
  if self.can_send_videos is Some(v) {
    object["can_send_videos"] = v.to_json()
  }
  if self.can_send_video_notes is Some(v) {
    object["can_send_video_notes"] = v.to_json()
  }
  if self.can_send_voice_notes is Some(v) {
    object["can_send_voice_notes"] = v.to_json()
  }
  if self.can_send_polls is Some(v) {
    object["can_send_polls"] = v.to_json()
  }
  if self.can_send_other_messages is Some(v) {
    object["can_send_other_messages"] = v.to_json()
  }
  if self.can_add_web_page_previews is Some(v) {
    object["can_add_web_page_previews"] = v.to_json()
  }
  if self.can_change_info is Some(v) {
    object["can_change_info"] = v.to_json()
  }
  if self.can_invite_users is Some(v) {
    object["can_invite_users"] = v.to_json()
  }
  if self.can_pin_messages is Some(v) {
    object["can_pin_messages"] = v.to_json()
  }
  if self.can_manage_topics is Some(v) {
    object["can_manage_topics"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for ChatPermissions with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for ChatPermissions"))
  }
  let can_send_messages : Bool? = if object.get("can_send_messages") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_audios : Bool? = if object.get("can_send_audios") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_documents : Bool? = if object.get("can_send_documents")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_photos : Bool? = if object.get("can_send_photos") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_videos : Bool? = if object.get("can_send_videos") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_video_notes : Bool? = if object.get("can_send_video_notes")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_voice_notes : Bool? = if object.get("can_send_voice_notes")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_polls : Bool? = if object.get("can_send_polls") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_other_messages : Bool? = if object.get("can_send_other_messages")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_add_web_page_previews : Bool? = if object.get(
      "can_add_web_page_previews",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_change_info : Bool? = if object.get("can_change_info") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_invite_users : Bool? = if object.get("can_invite_users") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_pin_messages : Bool? = if object.get("can_pin_messages") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_manage_topics : Bool? = if object.get("can_manage_topics") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    can_send_messages,
    can_send_audios,
    can_send_documents,
    can_send_photos,
    can_send_videos,
    can_send_video_notes,
    can_send_voice_notes,
    can_send_polls,
    can_send_other_messages,
    can_add_web_page_previews,
    can_change_info,
    can_invite_users,
    can_pin_messages,
    can_manage_topics,
  }
}

///|
/// Represents the rights of an administrator in a chat.
pub struct ChatAdministratorRights {
  is_anonymous : Bool
  can_manage_chat : Bool
  can_delete_messages : Bool
  can_manage_video_chats : Bool
  can_restrict_members : Bool
  can_promote_members : Bool
  can_change_info : Bool
  can_invite_users : Bool
  can_post_stories : Bool
  can_edit_stories : Bool
  can_delete_stories : Bool
  can_post_messages : Bool?
  can_edit_messages : Bool?
  can_pin_messages : Bool?
  can_manage_topics : Bool?
} derive(Show, Eq)

///|
/// Creates a new [ChatAdministratorRights].
pub fn ChatAdministratorRights::new(
  is_anonymous~ : Bool,
  can_manage_chat~ : Bool,
  can_delete_messages~ : Bool,
  can_manage_video_chats~ : Bool,
  can_restrict_members~ : Bool,
  can_promote_members~ : Bool,
  can_change_info~ : Bool,
  can_invite_users~ : Bool,
  can_post_stories~ : Bool,
  can_edit_stories~ : Bool,
  can_delete_stories~ : Bool,
  can_post_messages? : Bool,
  can_edit_messages? : Bool,
  can_pin_messages? : Bool,
  can_manage_topics? : Bool,
) -> ChatAdministratorRights {
  {
    is_anonymous,
    can_manage_chat,
    can_delete_messages,
    can_manage_video_chats,
    can_restrict_members,
    can_promote_members,
    can_change_info,
    can_invite_users,
    can_post_stories,
    can_edit_stories,
    can_delete_stories,
    can_post_messages,
    can_edit_messages,
    can_pin_messages,
    can_manage_topics,
  }
}

///|
pub impl ToJson for ChatAdministratorRights with to_json(self) {
  let object : Map[String, Json] = {
    "is_anonymous": self.is_anonymous.to_json(),
    "can_manage_chat": self.can_manage_chat.to_json(),
    "can_delete_messages": self.can_delete_messages.to_json(),
    "can_manage_video_chats": self.can_manage_video_chats.to_json(),
    "can_restrict_members": self.can_restrict_members.to_json(),
    "can_promote_members": self.can_promote_members.to_json(),
    "can_change_info": self.can_change_info.to_json(),
    "can_invite_users": self.can_invite_users.to_json(),
    "can_post_stories": self.can_post_stories.to_json(),
    "can_edit_stories": self.can_edit_stories.to_json(),
    "can_delete_stories": self.can_delete_stories.to_json(),
  }
  if self.can_post_messages is Some(v) {
    object["can_post_messages"] = v.to_json()
  }
  if self.can_edit_messages is Some(v) {
    object["can_edit_messages"] = v.to_json()
  }
  if self.can_pin_messages is Some(v) {
    object["can_pin_messages"] = v.to_json()
  }
  if self.can_manage_topics is Some(v) {
    object["can_manage_topics"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for ChatAdministratorRights with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for ChatAdministratorRights"),
    )
  }
  let is_anonymous : Bool = @json.from_json(object["is_anonymous"], path~)
  let can_manage_chat : Bool = @json.from_json(object["can_manage_chat"], path~)
  let can_delete_messages : Bool = @json.from_json(
    object["can_delete_messages"],
    path~,
  )
  let can_manage_video_chats : Bool = @json.from_json(
    object["can_manage_video_chats"],
    path~,
  )
  let can_restrict_members : Bool = @json.from_json(
    object["can_restrict_members"],
    path~,
  )
  let can_promote_members : Bool = @json.from_json(
    object["can_promote_members"],
    path~,
  )
  let can_change_info : Bool = @json.from_json(object["can_change_info"], path~)
  let can_invite_users : Bool = @json.from_json(
    object["can_invite_users"],
    path~,
  )
  let can_post_stories : Bool = @json.from_json(
    object["can_post_stories"],
    path~,
  )
  let can_edit_stories : Bool = @json.from_json(
    object["can_edit_stories"],
    path~,
  )
  let can_delete_stories : Bool = @json.from_json(
    object["can_delete_stories"],
    path~,
  )
  let can_post_messages : Bool? = if object.get("can_post_messages") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_edit_messages : Bool? = if object.get("can_edit_messages") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_pin_messages : Bool? = if object.get("can_pin_messages") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_manage_topics : Bool? = if object.get("can_manage_topics") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    is_anonymous,
    can_manage_chat,
    can_delete_messages,
    can_manage_video_chats,
    can_restrict_members,
    can_promote_members,
    can_change_info,
    can_invite_users,
    can_post_stories,
    can_edit_stories,
    can_delete_stories,
    can_post_messages,
    can_edit_messages,
    can_pin_messages,
    can_manage_topics,
  }
}
