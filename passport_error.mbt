///|
/// Represents an issue in one of the data fields that was provided by the user.
pub struct PassportElementErrorDataField {
  type_ : String
  field_name : String
  data_hash : String
  message : String
} derive(Show, Eq)

///|
/// Creates a new [PassportElementErrorDataField].
pub fn PassportElementErrorDataField::new(
  type_~ : String,
  field_name~ : String,
  data_hash~ : String,
  message~ : String,
) -> PassportElementErrorDataField {
  { type_, field_name, data_hash, message }
}

///|
/// Represents an issue with the front side of a document.
pub struct PassportElementErrorFrontSide {
  type_ : String
  file_hash : String
  message : String
} derive(Show, Eq)

///|
/// Creates a new [PassportElementErrorFrontSide].
pub fn PassportElementErrorFrontSide::new(
  type_~ : String,
  file_hash~ : String,
  message~ : String,
) -> PassportElementErrorFrontSide {
  { type_, file_hash, message }
}

///|
/// Represents an issue with the reverse side of a document.
pub struct PassportElementErrorReverseSide {
  type_ : String
  file_hash : String
  message : String
} derive(Show, Eq)

///|
/// Creates a new [PassportElementErrorReverseSide].
pub fn PassportElementErrorReverseSide::new(
  type_~ : String,
  file_hash~ : String,
  message~ : String,
) -> PassportElementErrorReverseSide {
  { type_, file_hash, message }
}

///|
/// Represents an issue with the selfie with a document.
pub struct PassportElementErrorSelfie {
  type_ : String
  file_hash : String
  message : String
} derive(Show, Eq)

///|
/// Creates a new [PassportElementErrorSelfie].
pub fn PassportElementErrorSelfie::new(
  type_~ : String,
  file_hash~ : String,
  message~ : String,
) -> PassportElementErrorSelfie {
  { type_, file_hash, message }
}

///|
/// Represents an issue with a document scan.
pub struct PassportElementErrorFile {
  type_ : String
  file_hash : String
  message : String
} derive(Show, Eq)

///|
/// Creates a new [PassportElementErrorFile].
pub fn PassportElementErrorFile::new(
  type_~ : String,
  file_hash~ : String,
  message~ : String,
) -> PassportElementErrorFile {
  { type_, file_hash, message }
}

///|
/// Represents an issue with a list of scans.
pub struct PassportElementErrorFiles {
  type_ : String
  file_hashes : Array[String]
  message : String
} derive(Show, Eq)

///|
/// Creates a new [PassportElementErrorFiles].
pub fn PassportElementErrorFiles::new(
  type_~ : String,
  file_hashes~ : Array[String],
  message~ : String,
) -> PassportElementErrorFiles {
  { type_, file_hashes, message }
}

///|
/// Represents an issue with one of the files that constitute the translation of a document.
pub struct PassportElementErrorTranslationFile {
  type_ : String
  file_hash : String
  message : String
} derive(Show, Eq)

///|
/// Creates a new [PassportElementErrorTranslationFile].
pub fn PassportElementErrorTranslationFile::new(
  type_~ : String,
  file_hash~ : String,
  message~ : String,
) -> PassportElementErrorTranslationFile {
  { type_, file_hash, message }
}

///|
/// Represents an issue with the translated version of a document.
pub struct PassportElementErrorTranslationFiles {
  type_ : String
  file_hashes : Array[String]
  message : String
} derive(Show, Eq)

///|
/// Creates a new [PassportElementErrorTranslationFiles].
pub fn PassportElementErrorTranslationFiles::new(
  type_~ : String,
  file_hashes~ : Array[String],
  message~ : String,
) -> PassportElementErrorTranslationFiles {
  { type_, file_hashes, message }
}

///|
/// Represents an issue in an unspecified place.
pub struct PassportElementErrorUnspecified {
  type_ : String
  element_hash : String
  message : String
} derive(Show, Eq)

///|
/// Creates a new [PassportElementErrorUnspecified].
pub fn PassportElementErrorUnspecified::new(
  type_~ : String,
  element_hash~ : String,
  message~ : String,
) -> PassportElementErrorUnspecified {
  { type_, element_hash, message }
}

///|
/// This object represents an error in the Telegram Passport element which was submitted
/// that should be resolved by the user.
pub(all) enum PassportElementError {
  DataField(PassportElementErrorDataField)
  FrontSide(PassportElementErrorFrontSide)
  ReverseSide(PassportElementErrorReverseSide)
  Selfie(PassportElementErrorSelfie)
  File(PassportElementErrorFile)
  Files(PassportElementErrorFiles)
  TranslationFile(PassportElementErrorTranslationFile)
  TranslationFiles(PassportElementErrorTranslationFiles)
  Unspecified(PassportElementErrorUnspecified)
} derive(Show, Eq)

///|
pub impl ToJson for PassportElementError with to_json(self) {
  match self {
    DataField(v) => {
      let object : Map[String, Json] = {
        "source": "data".to_json(),
        "type": v.type_.to_json(),
        "field_name": v.field_name.to_json(),
        "data_hash": v.data_hash.to_json(),
        "message": v.message.to_json(),
      }
      object.to_json()
    }
    FrontSide(v) => {
      let object : Map[String, Json] = {
        "source": "front_side".to_json(),
        "type": v.type_.to_json(),
        "file_hash": v.file_hash.to_json(),
        "message": v.message.to_json(),
      }
      object.to_json()
    }
    ReverseSide(v) => {
      let object : Map[String, Json] = {
        "source": "reverse_side".to_json(),
        "type": v.type_.to_json(),
        "file_hash": v.file_hash.to_json(),
        "message": v.message.to_json(),
      }
      object.to_json()
    }
    Selfie(v) => {
      let object : Map[String, Json] = {
        "source": "selfie".to_json(),
        "type": v.type_.to_json(),
        "file_hash": v.file_hash.to_json(),
        "message": v.message.to_json(),
      }
      object.to_json()
    }
    File(v) => {
      let object : Map[String, Json] = {
        "source": "file".to_json(),
        "type": v.type_.to_json(),
        "file_hash": v.file_hash.to_json(),
        "message": v.message.to_json(),
      }
      object.to_json()
    }
    Files(v) => {
      let object : Map[String, Json] = {
        "source": "files".to_json(),
        "type": v.type_.to_json(),
        "file_hashes": v.file_hashes.to_json(),
        "message": v.message.to_json(),
      }
      object.to_json()
    }
    TranslationFile(v) => {
      let object : Map[String, Json] = {
        "source": "translation_file".to_json(),
        "type": v.type_.to_json(),
        "file_hash": v.file_hash.to_json(),
        "message": v.message.to_json(),
      }
      object.to_json()
    }
    TranslationFiles(v) => {
      let object : Map[String, Json] = {
        "source": "translation_files".to_json(),
        "type": v.type_.to_json(),
        "file_hashes": v.file_hashes.to_json(),
        "message": v.message.to_json(),
      }
      object.to_json()
    }
    Unspecified(v) => {
      let object : Map[String, Json] = {
        "source": "unspecified".to_json(),
        "type": v.type_.to_json(),
        "element_hash": v.element_hash.to_json(),
        "message": v.message.to_json(),
      }
      object.to_json()
    }
  }
}

///|
pub impl @json.FromJson for PassportElementError with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for PassportElementError"),
    )
  }
  guard object["source"] is String(source) else {
    raise @json.JsonDecodeError(
      (path, "Expected source field for PassportElementError"),
    )
  }
  match source {
    "data" => {
      let type_ : String = @json.from_json(object["type"], path~)
      let field_name : String = @json.from_json(object["field_name"], path~)
      let data_hash : String = @json.from_json(object["data_hash"], path~)
      let message : String = @json.from_json(object["message"], path~)
      DataField({ type_, field_name, data_hash, message })
    }
    "front_side" => {
      let type_ : String = @json.from_json(object["type"], path~)
      let file_hash : String = @json.from_json(object["file_hash"], path~)
      let message : String = @json.from_json(object["message"], path~)
      FrontSide({ type_, file_hash, message })
    }
    "reverse_side" => {
      let type_ : String = @json.from_json(object["type"], path~)
      let file_hash : String = @json.from_json(object["file_hash"], path~)
      let message : String = @json.from_json(object["message"], path~)
      ReverseSide({ type_, file_hash, message })
    }
    "selfie" => {
      let type_ : String = @json.from_json(object["type"], path~)
      let file_hash : String = @json.from_json(object["file_hash"], path~)
      let message : String = @json.from_json(object["message"], path~)
      Selfie({ type_, file_hash, message })
    }
    "file" => {
      let type_ : String = @json.from_json(object["type"], path~)
      let file_hash : String = @json.from_json(object["file_hash"], path~)
      let message : String = @json.from_json(object["message"], path~)
      File({ type_, file_hash, message })
    }
    "files" => {
      let type_ : String = @json.from_json(object["type"], path~)
      let file_hashes : Array[String] = @json.from_json(
        object["file_hashes"],
        path~,
      )
      let message : String = @json.from_json(object["message"], path~)
      Files({ type_, file_hashes, message })
    }
    "translation_file" => {
      let type_ : String = @json.from_json(object["type"], path~)
      let file_hash : String = @json.from_json(object["file_hash"], path~)
      let message : String = @json.from_json(object["message"], path~)
      TranslationFile({ type_, file_hash, message })
    }
    "translation_files" => {
      let type_ : String = @json.from_json(object["type"], path~)
      let file_hashes : Array[String] = @json.from_json(
        object["file_hashes"],
        path~,
      )
      let message : String = @json.from_json(object["message"], path~)
      TranslationFiles({ type_, file_hashes, message })
    }
    "unspecified" => {
      let type_ : String = @json.from_json(object["type"], path~)
      let element_hash : String = @json.from_json(object["element_hash"], path~)
      let message : String = @json.from_json(object["message"], path~)
      Unspecified({ type_, element_hash, message })
    }
    _ =>
      raise @json.JsonDecodeError(
        (path, "Unknown source for PassportElementError: \{source}"),
      )
  }
}
