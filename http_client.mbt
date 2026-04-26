///|
#cfg(any(target="native", target="js"))
async fn telegram_http_get(
  url : String,
  headers~ : Map[String, String],
) -> (@http.Response, &@io.Data) {
  @http.get(url, headers~)
}

///|
#cfg(not(any(target="native", target="js")))
#warnings("-unused_async")
async fn telegram_http_get(
  _url : String,
  headers~ : Map[String, String],
) -> (@http.Response, &@io.Data) {
  ignore(headers)
  raise TelegramError::HttpError(
    code=0,
    body="HTTP requests are only supported on native and JavaScript targets",
  )
}

///|
#cfg(any(target="native", target="js"))
async fn telegram_http_post(
  url : String,
  body : &@io.Data,
  headers~ : Map[String, String],
) -> (@http.Response, &@io.Data) {
  @http.post(url, body, headers~)
}

///|
#cfg(not(any(target="native", target="js")))
#warnings("-unused_async")
async fn telegram_http_post(
  _url : String,
  body : &@io.Data,
  headers~ : Map[String, String],
) -> (@http.Response, &@io.Data) {
  ignore(body)
  ignore(headers)
  raise TelegramError::HttpError(
    code=0,
    body="HTTP requests are only supported on native and JavaScript targets",
  )
}
