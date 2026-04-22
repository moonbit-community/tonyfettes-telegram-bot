///|
/// Placeholder for a document object with basic file information.
pub struct DocumentPlaceholder {
  file_id : String
  file_unique_id : String
} derive(Debug, Eq)

///|
/// Creates a new [DocumentPlaceholder].
pub fn DocumentPlaceholder::new(
  file_id~ : String,
  file_unique_id~ : String,
) -> DocumentPlaceholder {
  { file_id, file_unique_id }
}

///|
pub impl ToJson for DocumentPlaceholder with to_json(self) {
  let object : Map[String, Json] = {
    "file_id": self.file_id.to_json(),
    "file_unique_id": self.file_unique_id.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for DocumentPlaceholder with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for DocumentPlaceholder"),
    )
  }
  let file_id : String = @json.from_json(object["file_id"], path~)
  let file_unique_id : String = @json.from_json(object["file_unique_id"], path~)
  { file_id, file_unique_id }
}

///|
/// The background is filled using the selected color.
pub struct BackgroundFillSolid {
  color : Int
} derive(Debug, Eq)

///|
/// Creates a new [BackgroundFillSolid].
pub fn BackgroundFillSolid::new(color~ : Int) -> BackgroundFillSolid {
  { color, }
}

///|
/// The background is a gradient fill.
pub struct BackgroundFillGradient {
  top_color : Int
  bottom_color : Int
  rotation_angle : Int
} derive(Debug, Eq)

///|
/// Creates a new [BackgroundFillGradient].
pub fn BackgroundFillGradient::new(
  top_color~ : Int,
  bottom_color~ : Int,
  rotation_angle~ : Int,
) -> BackgroundFillGradient {
  { top_color, bottom_color, rotation_angle }
}

///|
/// The background is a freeform gradient that rotates after every message in the chat.
pub struct BackgroundFillFreeformGradient {
  colors : Array[Int]
} derive(Debug, Eq)

///|
/// Creates a new [BackgroundFillFreeformGradient].
pub fn BackgroundFillFreeformGradient::new(
  colors~ : Array[Int],
) -> BackgroundFillFreeformGradient {
  { colors, }
}

///|
/// This object describes the way a background is filled based on the selected colors.
pub(all) enum BackgroundFill {
  Solid(BackgroundFillSolid)
  Gradient(BackgroundFillGradient)
  FreeformGradient(BackgroundFillFreeformGradient)
} derive(Debug, Eq)

///|
pub impl ToJson for BackgroundFill with to_json(self) {
  match self {
    Solid(v) => {
      let object : Map[String, Json] = {
        "type": "solid".to_json(),
        "color": v.color.to_json(),
      }
      object.to_json()
    }
    Gradient(v) => {
      let object : Map[String, Json] = {
        "type": "gradient".to_json(),
        "top_color": v.top_color.to_json(),
        "bottom_color": v.bottom_color.to_json(),
        "rotation_angle": v.rotation_angle.to_json(),
      }
      object.to_json()
    }
    FreeformGradient(v) => {
      let object : Map[String, Json] = {
        "type": "freeform_gradient".to_json(),
        "colors": v.colors.to_json(),
      }
      object.to_json()
    }
  }
}

///|
pub impl @json.FromJson for BackgroundFill with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for BackgroundFill"))
  }
  guard object["type"] is String(type_) else {
    raise @json.JsonDecodeError(
      (path, "Expected type field for BackgroundFill"),
    )
  }
  match type_ {
    "solid" => {
      let color : Int = @json.from_json(object["color"], path~)
      Solid({ color, })
    }
    "gradient" => {
      let top_color : Int = @json.from_json(object["top_color"], path~)
      let bottom_color : Int = @json.from_json(object["bottom_color"], path~)
      let rotation_angle : Int = @json.from_json(
        object["rotation_angle"],
        path~,
      )
      Gradient({ top_color, bottom_color, rotation_angle })
    }
    "freeform_gradient" => {
      let colors : Array[Int] = @json.from_json(object["colors"], path~)
      FreeformGradient({ colors, })
    }
    _ =>
      raise @json.JsonDecodeError(
        (path, "Unknown type for BackgroundFill: \{type_}"),
      )
  }
}

///|
/// The background is automatically filled based on the selected colors.
pub struct BackgroundTypeFill {
  fill : BackgroundFill
  dark_theme_dimming : Int
} derive(Debug, Eq)

///|
/// Creates a new [BackgroundTypeFill].
pub fn BackgroundTypeFill::new(
  fill~ : BackgroundFill,
  dark_theme_dimming~ : Int,
) -> BackgroundTypeFill {
  { fill, dark_theme_dimming }
}

///|
/// The background is a wallpaper in the JPEG format.
pub struct BackgroundTypeWallpaper {
  document : DocumentPlaceholder
  dark_theme_dimming : Int
  is_blurred : Bool?
  is_moving : Bool?
} derive(Debug, Eq)

///|
/// Creates a new [BackgroundTypeWallpaper].
pub fn BackgroundTypeWallpaper::new(
  document~ : DocumentPlaceholder,
  dark_theme_dimming~ : Int,
  is_blurred? : Bool,
  is_moving? : Bool,
) -> BackgroundTypeWallpaper {
  { document, dark_theme_dimming, is_blurred, is_moving }
}

///|
/// The background is a PNG or TGV pattern to be combined with the background fill
/// chosen by the user.
pub struct BackgroundTypePattern {
  document : DocumentPlaceholder
  fill : BackgroundFill
  intensity : Int
  is_inverted : Bool?
  is_moving : Bool?
} derive(Debug, Eq)

///|
/// Creates a new [BackgroundTypePattern].
pub fn BackgroundTypePattern::new(
  document~ : DocumentPlaceholder,
  fill~ : BackgroundFill,
  intensity~ : Int,
  is_inverted? : Bool,
  is_moving? : Bool,
) -> BackgroundTypePattern {
  { document, fill, intensity, is_inverted, is_moving }
}

///|
/// The background is taken directly from a built-in chat theme.
pub struct BackgroundTypeChatTheme {
  theme_name : String
} derive(Debug, Eq)

///|
/// Creates a new [BackgroundTypeChatTheme].
pub fn BackgroundTypeChatTheme::new(
  theme_name~ : String,
) -> BackgroundTypeChatTheme {
  { theme_name, }
}

///|
/// This object describes the type of a background.
pub(all) enum BackgroundType {
  Fill(BackgroundTypeFill)
  Wallpaper(BackgroundTypeWallpaper)
  Pattern(BackgroundTypePattern)
  ChatTheme(BackgroundTypeChatTheme)
} derive(Debug, Eq)

///|
pub impl ToJson for BackgroundType with to_json(self) {
  match self {
    Fill(v) => {
      let object : Map[String, Json] = {
        "type": "fill".to_json(),
        "fill": v.fill.to_json(),
        "dark_theme_dimming": v.dark_theme_dimming.to_json(),
      }
      object.to_json()
    }
    Wallpaper(v) => {
      let object : Map[String, Json] = {
        "type": "wallpaper".to_json(),
        "document": v.document.to_json(),
        "dark_theme_dimming": v.dark_theme_dimming.to_json(),
      }
      if v.is_blurred is Some(b) {
        object["is_blurred"] = b.to_json()
      }
      if v.is_moving is Some(m) {
        object["is_moving"] = m.to_json()
      }
      object.to_json()
    }
    Pattern(v) => {
      let object : Map[String, Json] = {
        "type": "pattern".to_json(),
        "document": v.document.to_json(),
        "fill": v.fill.to_json(),
        "intensity": v.intensity.to_json(),
      }
      if v.is_inverted is Some(i) {
        object["is_inverted"] = i.to_json()
      }
      if v.is_moving is Some(m) {
        object["is_moving"] = m.to_json()
      }
      object.to_json()
    }
    ChatTheme(v) => {
      let object : Map[String, Json] = {
        "type": "chat_theme".to_json(),
        "theme_name": v.theme_name.to_json(),
      }
      object.to_json()
    }
  }
}

///|
pub impl @json.FromJson for BackgroundType with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for BackgroundType"))
  }
  guard object["type"] is String(type_) else {
    raise @json.JsonDecodeError(
      (path, "Expected type field for BackgroundType"),
    )
  }
  match type_ {
    "fill" => {
      let fill : BackgroundFill = @json.from_json(object["fill"], path~)
      let dark_theme_dimming : Int = @json.from_json(
        object["dark_theme_dimming"],
        path~,
      )
      Fill({ fill, dark_theme_dimming })
    }
    "wallpaper" => {
      let document : DocumentPlaceholder = @json.from_json(
        object["document"],
        path~,
      )
      let dark_theme_dimming : Int = @json.from_json(
        object["dark_theme_dimming"],
        path~,
      )
      let is_blurred : Bool? = if object.get("is_blurred") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let is_moving : Bool? = if object.get("is_moving") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Wallpaper({ document, dark_theme_dimming, is_blurred, is_moving })
    }
    "pattern" => {
      let document : DocumentPlaceholder = @json.from_json(
        object["document"],
        path~,
      )
      let fill : BackgroundFill = @json.from_json(object["fill"], path~)
      let intensity : Int = @json.from_json(object["intensity"], path~)
      let is_inverted : Bool? = if object.get("is_inverted") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let is_moving : Bool? = if object.get("is_moving") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Pattern({ document, fill, intensity, is_inverted, is_moving })
    }
    "chat_theme" => {
      let theme_name : String = @json.from_json(object["theme_name"], path~)
      ChatTheme({ theme_name, })
    }
    _ =>
      raise @json.JsonDecodeError(
        (path, "Unknown type for BackgroundType: \{type_}"),
      )
  }
}

///|
/// This object represents a chat background.
pub struct ChatBackground {
  type_ : BackgroundType
} derive(Debug, Eq)

///|
/// Creates a new [ChatBackground].
pub fn ChatBackground::new(type_~ : BackgroundType) -> ChatBackground {
  { type_, }
}

///|
pub impl ToJson for ChatBackground with to_json(self) {
  let object : Map[String, Json] = { "type": self.type_.to_json() }
  object.to_json()
}

///|
pub impl @json.FromJson for ChatBackground with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for ChatBackground"))
  }
  let type_ : BackgroundType = @json.from_json(object["type"], path~)
  { type_, }
}
