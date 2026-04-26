///|
/// Represents a point on the map.
pub struct Location {
  latitude : Double
  longitude : Double
  horizontal_accuracy : Double?
  live_period : Int?
  heading : Int?
  proximity_alert_radius : Int?
} derive(Debug, Eq)

///|
/// Creates a new [Location].
pub fn Location::new(
  latitude~ : Double,
  longitude~ : Double,
  horizontal_accuracy? : Double,
  live_period? : Int,
  heading? : Int,
  proximity_alert_radius? : Int,
) -> Location {
  {
    latitude,
    longitude,
    horizontal_accuracy,
    live_period,
    heading,
    proximity_alert_radius,
  }
}

///|
pub impl ToJson for Location with to_json(self) {
  let object : Map[String, Json] = {
    "latitude": self.latitude.to_json(),
    "longitude": self.longitude.to_json(),
  }
  if self.horizontal_accuracy is Some(v) {
    object["horizontal_accuracy"] = v.to_json()
  }
  if self.live_period is Some(v) {
    object["live_period"] = v.to_json()
  }
  if self.heading is Some(v) {
    object["heading"] = v.to_json()
  }
  if self.proximity_alert_radius is Some(v) {
    object["proximity_alert_radius"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for Location with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for Location"))
  }
  let latitude : Double = @json.from_json(object["latitude"], path~)
  let longitude : Double = @json.from_json(object["longitude"], path~)
  let horizontal_accuracy : Double? = if object.get("horizontal_accuracy")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let live_period : Int? = if object.get("live_period") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let heading : Int? = if object.get("heading") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let proximity_alert_radius : Int? = if object.get("proximity_alert_radius")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    latitude,
    longitude,
    horizontal_accuracy,
    live_period,
    heading,
    proximity_alert_radius,
  }
}
