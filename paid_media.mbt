///|
/// This object describes paid media. Currently, it can be one of
/// PaidMediaPreview, PaidMediaPhoto, or PaidMediaVideo.
pub(all) enum PaidMedia {
  Preview(PaidMediaPreview)
  Photo(PaidMediaPhoto)
  Video(PaidMediaVideo)
} derive(Show, Eq)

///|
/// The paid media isn't available before the payment.
pub struct PaidMediaPreview {
  width : Int?
  height : Int?
  duration : Int?
} derive(Show, Eq)

///|
/// Creates a new [PaidMediaPreview].
pub fn PaidMediaPreview::new(
  width? : Int,
  height? : Int,
  duration? : Int,
) -> PaidMediaPreview {
  { width, height, duration }
}

///|
/// The paid media is a photo.
pub struct PaidMediaPhoto {
  photo : Array[PhotoSize]
} derive(Show, Eq)

///|
/// Creates a new [PaidMediaPhoto].
pub fn PaidMediaPhoto::new(photo~ : Array[PhotoSize]) -> PaidMediaPhoto {
  { photo, }
}

///|
/// The paid media is a video.
pub struct PaidMediaVideo {
  video : Video
} derive(Show, Eq)

///|
/// Creates a new [PaidMediaVideo].
pub fn PaidMediaVideo::new(video~ : Video) -> PaidMediaVideo {
  { video, }
}

///|
pub impl ToJson for PaidMedia with to_json(self) {
  match self {
    Preview(v) => {
      let object : Map[String, Json] = { "type": "preview".to_json() }
      if v.width is Some(w) {
        object["width"] = w.to_json()
      }
      if v.height is Some(h) {
        object["height"] = h.to_json()
      }
      if v.duration is Some(d) {
        object["duration"] = d.to_json()
      }
      object.to_json()
    }
    Photo(v) => {
      let object : Map[String, Json] = {
        "type": "photo".to_json(),
        "photo": v.photo.to_json(),
      }
      object.to_json()
    }
    Video(v) => {
      let object : Map[String, Json] = {
        "type": "video".to_json(),
        "video": v.video.to_json(),
      }
      object.to_json()
    }
  }
}

///|
pub impl @json.FromJson for PaidMedia with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for PaidMedia"))
  }
  guard object["type"] is String(type_) else {
    raise @json.JsonDecodeError((path, "Expected type field for PaidMedia"))
  }
  match type_ {
    "preview" => {
      let width : Int? = if object.get("width") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let height : Int? = if object.get("height") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let duration : Int? = if object.get("duration") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Preview({ width, height, duration })
    }
    "photo" => Photo({ photo: @json.from_json(object["photo"], path~) })
    "video" => Video({ video: @json.from_json(object["video"], path~) })
    _ => raise @json.JsonDecodeError((path, "Unknown PaidMedia type"))
  }
}

///|
/// Describes the paid media added to a message.
pub struct PaidMediaInfo {
  star_count : Int
  paid_media : Array[PaidMedia]
} derive(Show, Eq)

///|
/// Creates a new [PaidMediaInfo].
pub fn PaidMediaInfo::new(
  star_count~ : Int,
  paid_media~ : Array[PaidMedia],
) -> PaidMediaInfo {
  { star_count, paid_media }
}

///|
pub impl ToJson for PaidMediaInfo with to_json(self) {
  let object : Map[String, Json] = {
    "star_count": self.star_count.to_json(),
    "paid_media": self.paid_media.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for PaidMediaInfo with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for PaidMediaInfo"))
  }
  let star_count : Int = @json.from_json(object["star_count"], path~)
  let paid_media : Array[PaidMedia] = @json.from_json(
    object["paid_media"],
    path~,
  )
  { star_count, paid_media }
}
