///|
test "Location JSON round-trip" {
  let location = Location::new(
    latitude=40.7128,
    longitude=-74.0060,
    horizontal_accuracy=100.0,
    heading=180,
  )
  let json = @json.to_json(location)
  let parsed : Location = @json.from_json(json)
  inspect(parsed.latitude, content="40.7128")
  inspect(parsed.longitude, content="-74.006")
  inspect(parsed.horizontal_accuracy, content="Some(100)")
  inspect(parsed.heading, content="Some(180)")
  inspect(parsed.live_period, content="None")
  inspect(parsed.proximity_alert_radius, content="None")
}

///|
test "Location JSON minimal" {
  let location = Location::new(latitude=51.5074, longitude=-0.1278)
  let json = @json.to_json(location)
  let parsed : Location = @json.from_json(json)
  inspect(parsed.latitude, content="51.5074")
  inspect(parsed.longitude, content="-0.1278")
  inspect(parsed.horizontal_accuracy, content="None")
}

///|
test "Location from fixed JSON with all fields" {
  let json = @json.parse(
    (
      #|{"latitude":40.7128,"longitude":-74.006,"horizontal_accuracy":15.5,"live_period":300,"heading":90,"proximity_alert_radius":100}
    ),
  )
  let location : Location = @json.from_json(json)
  inspect(location.latitude, content="40.7128")
  inspect(location.longitude, content="-74.006")
  inspect(location.horizontal_accuracy, content="Some(15.5)")
  inspect(location.live_period, content="Some(300)")
  inspect(location.heading, content="Some(90)")
  inspect(location.proximity_alert_radius, content="Some(100)")
}

///|
test "Location from fixed JSON minimal" {
  let json = @json.parse(
    (
      #|{"latitude":51.5074,"longitude":-0.1278}
    ),
  )
  let location : Location = @json.from_json(json)
  inspect(location.latitude, content="51.5074")
  inspect(location.longitude, content="-0.1278")
  inspect(location.horizontal_accuracy, content="None")
  inspect(location.live_period, content="None")
  inspect(location.heading, content="None")
  inspect(location.proximity_alert_radius, content="None")
}
