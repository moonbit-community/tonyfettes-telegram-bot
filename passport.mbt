///|
/// This object represents a file uploaded to Telegram Passport. Currently all Telegram Passport
/// files are in JPEG format when decrypted and don't exceed 10MB.
pub struct PassportFile {
  file_id : String
  file_unique_id : String
  file_size : Int64
  file_date : Int
} derive(Debug, Eq)

///|
/// Creates a new [PassportFile].
pub fn PassportFile::new(
  file_id~ : String,
  file_unique_id~ : String,
  file_size~ : Int64,
  file_date~ : Int,
) -> PassportFile {
  { file_id, file_unique_id, file_size, file_date }
}

///|
pub impl ToJson for PassportFile with to_json(self) {
  let object : Map[String, Json] = {
    "file_id": self.file_id.to_json(),
    "file_unique_id": self.file_unique_id.to_json(),
    "file_size": int64_to_json(self.file_size),
    "file_date": self.file_date.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for PassportFile with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for PassportFile"))
  }
  let file_id : String = @json.from_json(object["file_id"], path~)
  let file_unique_id : String = @json.from_json(object["file_unique_id"], path~)
  let file_size : Int64 = int64_from_json(object["file_size"], path)
  let file_date : Int = @json.from_json(object["file_date"], path~)
  { file_id, file_unique_id, file_size, file_date }
}

///|
/// Describes data required for decrypting and authenticating EncryptedPassportElement.
pub struct EncryptedCredentials {
  data : String
  hash : String
  secret : String
} derive(Debug, Eq)

///|
/// Creates a new [EncryptedCredentials].
pub fn EncryptedCredentials::new(
  data~ : String,
  hash~ : String,
  secret~ : String,
) -> EncryptedCredentials {
  { data, hash, secret }
}

///|
pub impl ToJson for EncryptedCredentials with to_json(self) {
  let object : Map[String, Json] = {
    "data": self.data.to_json(),
    "hash": self.hash.to_json(),
    "secret": self.secret.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for EncryptedCredentials with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for EncryptedCredentials"),
    )
  }
  let data : String = @json.from_json(object["data"], path~)
  let hash : String = @json.from_json(object["hash"], path~)
  let secret : String = @json.from_json(object["secret"], path~)
  { data, hash, secret }
}

///|
/// Describes documents or other Telegram Passport elements shared with the bot by the user.
pub struct EncryptedPassportElement {
  type_ : String
  data : String?
  phone_number : String?
  email : String?
  files : Array[PassportFile]?
  front_side : PassportFile?
  reverse_side : PassportFile?
  selfie : PassportFile?
  translation : Array[PassportFile]?
  hash : String
} derive(Debug, Eq)

///|
/// Creates a new [EncryptedPassportElement].
pub fn EncryptedPassportElement::new(
  type_~ : String,
  hash~ : String,
  data? : String,
  phone_number? : String,
  email? : String,
  files? : Array[PassportFile],
  front_side? : PassportFile,
  reverse_side? : PassportFile,
  selfie? : PassportFile,
  translation? : Array[PassportFile],
) -> EncryptedPassportElement {
  {
    type_,
    data,
    phone_number,
    email,
    files,
    front_side,
    reverse_side,
    selfie,
    translation,
    hash,
  }
}

///|
pub impl ToJson for EncryptedPassportElement with to_json(self) {
  let object : Map[String, Json] = {
    "type": self.type_.to_json(),
    "hash": self.hash.to_json(),
  }
  if self.data is Some(v) {
    object["data"] = v.to_json()
  }
  if self.phone_number is Some(v) {
    object["phone_number"] = v.to_json()
  }
  if self.email is Some(v) {
    object["email"] = v.to_json()
  }
  if self.files is Some(v) {
    object["files"] = v.to_json()
  }
  if self.front_side is Some(v) {
    object["front_side"] = v.to_json()
  }
  if self.reverse_side is Some(v) {
    object["reverse_side"] = v.to_json()
  }
  if self.selfie is Some(v) {
    object["selfie"] = v.to_json()
  }
  if self.translation is Some(v) {
    object["translation"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for EncryptedPassportElement with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for EncryptedPassportElement"),
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let hash : String = @json.from_json(object["hash"], path~)
  let data : String? = if object.get("data") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let phone_number : String? = if object.get("phone_number") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let email : String? = if object.get("email") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let files : Array[PassportFile]? = if object.get("files") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let front_side : PassportFile? = if object.get("front_side") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reverse_side : PassportFile? = if object.get("reverse_side") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let selfie : PassportFile? = if object.get("selfie") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let translation : Array[PassportFile]? = if object.get("translation")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    data,
    phone_number,
    email,
    files,
    front_side,
    reverse_side,
    selfie,
    translation,
    hash,
  }
}

///|
/// Describes Telegram Passport data shared with the bot by the user.
pub struct PassportData {
  data : Array[EncryptedPassportElement]
  credentials : EncryptedCredentials
} derive(Debug, Eq)

///|
/// Creates a new [PassportData].
pub fn PassportData::new(
  data~ : Array[EncryptedPassportElement],
  credentials~ : EncryptedCredentials,
) -> PassportData {
  { data, credentials }
}

///|
pub impl ToJson for PassportData with to_json(self) {
  let object : Map[String, Json] = {
    "data": self.data.to_json(),
    "credentials": self.credentials.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for PassportData with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for PassportData"))
  }
  let data : Array[EncryptedPassportElement] = @json.from_json(
    object["data"],
    path~,
  )
  let credentials : EncryptedCredentials = @json.from_json(
    object["credentials"],
    path~,
  )
  { data, credentials }
}
