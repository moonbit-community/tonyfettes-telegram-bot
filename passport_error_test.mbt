///|
test "PassportElementErrorDataField JSON round-trip" {
  let error : PassportElementError = DataField(
    PassportElementErrorDataField::new(
      type_="passport",
      field_name="first_name",
      data_hash="abc123",
      message="Invalid first name",
    ),
  )
  let json = @json.to_json(error)
  let parsed : PassportElementError = @json.from_json(json)
  guard parsed is DataField(v) else {
    fail("Expected PassportElementError::DataField")
  }
  inspect(v.type_, content="passport")
  inspect(v.field_name, content="first_name")
  inspect(v.data_hash, content="abc123")
  inspect(v.message, content="Invalid first name")
}

///|
test "PassportElementErrorFrontSide JSON round-trip" {
  let error : PassportElementError = FrontSide(
    PassportElementErrorFrontSide::new(
      type_="driver_license",
      file_hash="hash123",
      message="Photo is blurry",
    ),
  )
  let json = @json.to_json(error)
  let parsed : PassportElementError = @json.from_json(json)
  guard parsed is FrontSide(v) else {
    fail("Expected PassportElementError::FrontSide")
  }
  inspect(v.type_, content="driver_license")
  inspect(v.file_hash, content="hash123")
  inspect(v.message, content="Photo is blurry")
}

///|
test "PassportElementErrorReverseSide JSON round-trip" {
  let error : PassportElementError = ReverseSide(
    PassportElementErrorReverseSide::new(
      type_="identity_card",
      file_hash="hash456",
      message="Document expired",
    ),
  )
  let json = @json.to_json(error)
  let parsed : PassportElementError = @json.from_json(json)
  guard parsed is ReverseSide(v) else {
    fail("Expected PassportElementError::ReverseSide")
  }
  inspect(v.type_, content="identity_card")
  inspect(v.file_hash, content="hash456")
  inspect(v.message, content="Document expired")
}

///|
test "PassportElementErrorSelfie JSON round-trip" {
  let error : PassportElementError = Selfie(
    PassportElementErrorSelfie::new(
      type_="passport",
      file_hash="selfie_hash",
      message="Face not visible",
    ),
  )
  let json = @json.to_json(error)
  let parsed : PassportElementError = @json.from_json(json)
  guard parsed is Selfie(v) else {
    fail("Expected PassportElementError::Selfie")
  }
  inspect(v.type_, content="passport")
  inspect(v.file_hash, content="selfie_hash")
  inspect(v.message, content="Face not visible")
}

///|
test "PassportElementErrorFile JSON round-trip" {
  let error : PassportElementError = File(
    PassportElementErrorFile::new(
      type_="utility_bill",
      file_hash="file_hash",
      message="File corrupted",
    ),
  )
  let json = @json.to_json(error)
  let parsed : PassportElementError = @json.from_json(json)
  guard parsed is File(v) else { fail("Expected PassportElementError::File") }
  inspect(v.type_, content="utility_bill")
  inspect(v.file_hash, content="file_hash")
  inspect(v.message, content="File corrupted")
}

///|
test "PassportElementErrorFiles JSON round-trip" {
  let error : PassportElementError = Files(
    PassportElementErrorFiles::new(
      type_="bank_statement",
      file_hashes=["hash1", "hash2", "hash3"],
      message="Multiple files invalid",
    ),
  )
  let json = @json.to_json(error)
  let parsed : PassportElementError = @json.from_json(json)
  guard parsed is Files(v) else { fail("Expected PassportElementError::Files") }
  inspect(v.type_, content="bank_statement")
  inspect(v.file_hashes, content="[\"hash1\", \"hash2\", \"hash3\"]")
  inspect(v.message, content="Multiple files invalid")
}

///|
test "PassportElementErrorTranslationFile JSON round-trip" {
  let error : PassportElementError = TranslationFile(
    PassportElementErrorTranslationFile::new(
      type_="passport",
      file_hash="trans_hash",
      message="Translation unclear",
    ),
  )
  let json = @json.to_json(error)
  let parsed : PassportElementError = @json.from_json(json)
  guard parsed is TranslationFile(v) else {
    fail("Expected PassportElementError::TranslationFile")
  }
  inspect(v.type_, content="passport")
  inspect(v.file_hash, content="trans_hash")
  inspect(v.message, content="Translation unclear")
}

///|
test "PassportElementErrorTranslationFiles JSON round-trip" {
  let error : PassportElementError = TranslationFiles(
    PassportElementErrorTranslationFiles::new(
      type_="driver_license",
      file_hashes=["trans1", "trans2"],
      message="Translations incomplete",
    ),
  )
  let json = @json.to_json(error)
  let parsed : PassportElementError = @json.from_json(json)
  guard parsed is TranslationFiles(v) else {
    fail("Expected PassportElementError::TranslationFiles")
  }
  inspect(v.type_, content="driver_license")
  inspect(v.file_hashes, content="[\"trans1\", \"trans2\"]")
  inspect(v.message, content="Translations incomplete")
}

///|
test "PassportElementErrorUnspecified JSON round-trip" {
  let error : PassportElementError = Unspecified(
    PassportElementErrorUnspecified::new(
      type_="personal_details",
      element_hash="elem_hash",
      message="Unspecified error",
    ),
  )
  let json = @json.to_json(error)
  let parsed : PassportElementError = @json.from_json(json)
  guard parsed is Unspecified(v) else {
    fail("Expected PassportElementError::Unspecified")
  }
  inspect(v.type_, content="personal_details")
  inspect(v.element_hash, content="elem_hash")
  inspect(v.message, content="Unspecified error")
}

///|
test "PassportElementError::DataField from fixed JSON" {
  let json = @json.parse(
    (
      #|{"source":"data","type":"passport","field_name":"surname","data_hash":"abc123hash","message":"Bad surname data"}
    ),
  )
  let error : PassportElementError = @json.from_json(json)
  guard error is DataField(v) else { fail("Expected DataField") }
  inspect(v.type_, content="passport")
  inspect(v.field_name, content="surname")
  inspect(v.data_hash, content="abc123hash")
  inspect(v.message, content="Bad surname data")
}

///|
test "PassportElementError::FrontSide from fixed JSON" {
  let json = @json.parse(
    (
      #|{"source":"front_side","type":"driver_license","file_hash":"fronthash","message":"Front side blurry"}
    ),
  )
  let error : PassportElementError = @json.from_json(json)
  guard error is FrontSide(v) else { fail("Expected FrontSide") }
  inspect(v.type_, content="driver_license")
  inspect(v.file_hash, content="fronthash")
  inspect(v.message, content="Front side blurry")
}

///|
test "PassportElementError::ReverseSide from fixed JSON" {
  let json = @json.parse(
    (
      #|{"source":"reverse_side","type":"identity_card","file_hash":"reversehash","message":"Reverse side expired"}
    ),
  )
  let error : PassportElementError = @json.from_json(json)
  guard error is ReverseSide(v) else { fail("Expected ReverseSide") }
  inspect(v.type_, content="identity_card")
  inspect(v.file_hash, content="reversehash")
  inspect(v.message, content="Reverse side expired")
}

///|
test "PassportElementError::Selfie from fixed JSON" {
  let json = @json.parse(
    (
      #|{"source":"selfie","type":"passport","file_hash":"selfiehash","message":"No face visible"}
    ),
  )
  let error : PassportElementError = @json.from_json(json)
  guard error is Selfie(v) else { fail("Expected Selfie") }
  inspect(v.type_, content="passport")
  inspect(v.file_hash, content="selfiehash")
  inspect(v.message, content="No face visible")
}

///|
test "PassportElementError::File from fixed JSON" {
  let json = @json.parse(
    (
      #|{"source":"file","type":"utility_bill","file_hash":"filehash","message":"File is corrupted"}
    ),
  )
  let error : PassportElementError = @json.from_json(json)
  guard error is File(v) else { fail("Expected File") }
  inspect(v.type_, content="utility_bill")
  inspect(v.file_hash, content="filehash")
  inspect(v.message, content="File is corrupted")
}

///|
test "PassportElementError::Files from fixed JSON" {
  let json = @json.parse(
    (
      #|{"source":"files","type":"bank_statement","file_hashes":["h1","h2"],"message":"Some files invalid"}
    ),
  )
  let error : PassportElementError = @json.from_json(json)
  guard error is Files(v) else { fail("Expected Files") }
  inspect(v.type_, content="bank_statement")
  inspect(v.file_hashes, content="[\"h1\", \"h2\"]")
  inspect(v.message, content="Some files invalid")
}

///|
test "PassportElementError::TranslationFile from fixed JSON" {
  let json = @json.parse(
    (
      #|{"source":"translation_file","type":"passport","file_hash":"transhash","message":"Translation unclear"}
    ),
  )
  let error : PassportElementError = @json.from_json(json)
  guard error is TranslationFile(v) else { fail("Expected TranslationFile") }
  inspect(v.type_, content="passport")
  inspect(v.file_hash, content="transhash")
  inspect(v.message, content="Translation unclear")
}

///|
test "PassportElementError::TranslationFiles from fixed JSON" {
  let json = @json.parse(
    (
      #|{"source":"translation_files","type":"driver_license","file_hashes":["t1","t2","t3"],"message":"Multiple translations invalid"}
    ),
  )
  let error : PassportElementError = @json.from_json(json)
  guard error is TranslationFiles(v) else { fail("Expected TranslationFiles") }
  inspect(v.type_, content="driver_license")
  inspect(v.file_hashes, content="[\"t1\", \"t2\", \"t3\"]")
  inspect(v.message, content="Multiple translations invalid")
}

///|
test "PassportElementError::Unspecified from fixed JSON" {
  let json = @json.parse(
    (
      #|{"source":"unspecified","type":"personal_details","element_hash":"elemhash","message":"Element has error"}
    ),
  )
  let error : PassportElementError = @json.from_json(json)
  guard error is Unspecified(v) else { fail("Expected Unspecified") }
  inspect(v.type_, content="personal_details")
  inspect(v.element_hash, content="elemhash")
  inspect(v.message, content="Element has error")
}
