///|
/// Describes the parameters of a suggested post.
pub struct SuggestedPostParameters {
  text : String?
  link_preview_options : LinkPreviewOptions?
  is_disabled : Bool?
} derive(Show, Eq)

///|
/// Creates a new [SuggestedPostParameters].
pub fn SuggestedPostParameters::new(
  text? : String,
  link_preview_options? : LinkPreviewOptions,
  is_disabled? : Bool,
) -> SuggestedPostParameters {
  { text, link_preview_options, is_disabled }
}

///|
pub impl ToJson for SuggestedPostParameters with to_json(self) {
  let object : Map[String, Json] = {}
  if self.text is Some(v) {
    object["text"] = v.to_json()
  }
  if self.link_preview_options is Some(v) {
    object["link_preview_options"] = v.to_json()
  }
  if self.is_disabled is Some(v) {
    object["is_disabled"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for SuggestedPostParameters with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for SuggestedPostParameters"),
    )
  }
  let text : String? = if object.get("text") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let link_preview_options : LinkPreviewOptions? = if object.get(
      "link_preview_options",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let is_disabled : Bool? = if object.get("is_disabled") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { text, link_preview_options, is_disabled }
}

///|
/// Describes a suggested post in a channel direct messages chat.
pub struct SuggestedPostInfo {
  suggested_post_parameters : SuggestedPostParameters?
  is_approved : Bool
  is_declined : Bool
  is_paid : Bool
} derive(Show, Eq)

///|
/// Creates a new [SuggestedPostInfo].
pub fn SuggestedPostInfo::new(
  suggested_post_parameters? : SuggestedPostParameters,
  is_approved~ : Bool,
  is_declined~ : Bool,
  is_paid~ : Bool,
) -> SuggestedPostInfo {
  { suggested_post_parameters, is_approved, is_declined, is_paid }
}

///|
pub impl ToJson for SuggestedPostInfo with to_json(self) {
  let object : Map[String, Json] = {
    "is_approved": self.is_approved.to_json(),
    "is_declined": self.is_declined.to_json(),
    "is_paid": self.is_paid.to_json(),
  }
  if self.suggested_post_parameters is Some(v) {
    object["suggested_post_parameters"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for SuggestedPostInfo with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for SuggestedPostInfo"))
  }
  let suggested_post_parameters : SuggestedPostParameters? = if object.get(
      "suggested_post_parameters",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let is_approved : Bool = @json.from_json(object["is_approved"], path~)
  let is_declined : Bool = @json.from_json(object["is_declined"], path~)
  let is_paid : Bool = @json.from_json(object["is_paid"], path~)
  { suggested_post_parameters, is_approved, is_declined, is_paid }
}

///|
/// Describes the price of a suggested post.
pub struct SuggestedPostPrice {
  star_count : Int
} derive(Show, Eq)

///|
/// Creates a new [SuggestedPostPrice].
pub fn SuggestedPostPrice::new(star_count~ : Int) -> SuggestedPostPrice {
  { star_count, }
}

///|
pub impl ToJson for SuggestedPostPrice with to_json(self) {
  let object : Map[String, Json] = { "star_count": self.star_count.to_json() }
  object.to_json()
}

///|
pub impl @json.FromJson for SuggestedPostPrice with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for SuggestedPostPrice"),
    )
  }
  let star_count : Int = @json.from_json(object["star_count"], path~)
  { star_count, }
}

///|
/// Describes a service message about the approval of a suggested post.
pub struct SuggestedPostApproved {
  user : User
  suggested_post_info : SuggestedPostInfo
} derive(Show, Eq)

///|
/// Creates a new [SuggestedPostApproved].
pub fn SuggestedPostApproved::new(
  user~ : User,
  suggested_post_info~ : SuggestedPostInfo,
) -> SuggestedPostApproved {
  { user, suggested_post_info }
}

///|
pub impl ToJson for SuggestedPostApproved with to_json(self) {
  let object : Map[String, Json] = {
    "user": self.user.to_json(),
    "suggested_post_info": self.suggested_post_info.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for SuggestedPostApproved with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for SuggestedPostApproved"),
    )
  }
  let user : User = @json.from_json(object["user"], path~)
  let suggested_post_info : SuggestedPostInfo = @json.from_json(
    object["suggested_post_info"],
    path~,
  )
  { user, suggested_post_info }
}

///|
/// Describes a service message about the rejection of a suggested post.
pub struct SuggestedPostDeclined {
  user : User
  suggested_post_info : SuggestedPostInfo
} derive(Show, Eq)

///|
/// Creates a new [SuggestedPostDeclined].
pub fn SuggestedPostDeclined::new(
  user~ : User,
  suggested_post_info~ : SuggestedPostInfo,
) -> SuggestedPostDeclined {
  { user, suggested_post_info }
}

///|
pub impl ToJson for SuggestedPostDeclined with to_json(self) {
  let object : Map[String, Json] = {
    "user": self.user.to_json(),
    "suggested_post_info": self.suggested_post_info.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for SuggestedPostDeclined with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for SuggestedPostDeclined"),
    )
  }
  let user : User = @json.from_json(object["user"], path~)
  let suggested_post_info : SuggestedPostInfo = @json.from_json(
    object["suggested_post_info"],
    path~,
  )
  { user, suggested_post_info }
}

///|
/// Describes a service message about a successful payment for a suggested post.
pub struct SuggestedPostPaid {
  user : User
  suggested_post_info : SuggestedPostInfo
} derive(Show, Eq)

///|
/// Creates a new [SuggestedPostPaid].
pub fn SuggestedPostPaid::new(
  user~ : User,
  suggested_post_info~ : SuggestedPostInfo,
) -> SuggestedPostPaid {
  { user, suggested_post_info }
}

///|
pub impl ToJson for SuggestedPostPaid with to_json(self) {
  let object : Map[String, Json] = {
    "user": self.user.to_json(),
    "suggested_post_info": self.suggested_post_info.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for SuggestedPostPaid with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for SuggestedPostPaid"))
  }
  let user : User = @json.from_json(object["user"], path~)
  let suggested_post_info : SuggestedPostInfo = @json.from_json(
    object["suggested_post_info"],
    path~,
  )
  { user, suggested_post_info }
}

///|
/// Describes a service message about the failed approval of a suggested post.
pub struct SuggestedPostApprovalFailed {
  user : User
  suggested_post_info : SuggestedPostInfo
} derive(Show, Eq)

///|
/// Creates a new [SuggestedPostApprovalFailed].
pub fn SuggestedPostApprovalFailed::new(
  user~ : User,
  suggested_post_info~ : SuggestedPostInfo,
) -> SuggestedPostApprovalFailed {
  { user, suggested_post_info }
}

///|
pub impl ToJson for SuggestedPostApprovalFailed with to_json(self) {
  let object : Map[String, Json] = {
    "user": self.user.to_json(),
    "suggested_post_info": self.suggested_post_info.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for SuggestedPostApprovalFailed with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for SuggestedPostApprovalFailed"),
    )
  }
  let user : User = @json.from_json(object["user"], path~)
  let suggested_post_info : SuggestedPostInfo = @json.from_json(
    object["suggested_post_info"],
    path~,
  )
  { user, suggested_post_info }
}
