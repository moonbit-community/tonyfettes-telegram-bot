///|
/// This object contains basic information about an invoice.
pub struct Invoice {
  title : String
  description : String
  start_parameter : String
  currency : String
  total_amount : Int
} derive(Debug, Eq)

///|
/// Creates a new [Invoice].
pub fn Invoice::new(
  title~ : String,
  description~ : String,
  start_parameter~ : String,
  currency~ : String,
  total_amount~ : Int,
) -> Invoice {
  { title, description, start_parameter, currency, total_amount }
}

///|
pub impl ToJson for Invoice with to_json(self) {
  let object : Map[String, Json] = {
    "title": self.title.to_json(),
    "description": self.description.to_json(),
    "start_parameter": self.start_parameter.to_json(),
    "currency": self.currency.to_json(),
    "total_amount": self.total_amount.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for Invoice with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for Invoice"))
  }
  let title : String = @json.from_json(object["title"], path~)
  let description : String = @json.from_json(object["description"], path~)
  let start_parameter : String = @json.from_json(
    object["start_parameter"],
    path~,
  )
  let currency : String = @json.from_json(object["currency"], path~)
  let total_amount : Int = @json.from_json(object["total_amount"], path~)
  { title, description, start_parameter, currency, total_amount }
}

///|
/// This object represents a portion of the price for goods or services.
pub struct LabeledPrice {
  label : String
  amount : Int
} derive(Debug, Eq)

///|
/// Creates a new [LabeledPrice].
pub fn LabeledPrice::new(label~ : String, amount~ : Int) -> LabeledPrice {
  { label, amount }
}

///|
pub impl ToJson for LabeledPrice with to_json(self) {
  let object : Map[String, Json] = {
    "label": self.label.to_json(),
    "amount": self.amount.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for LabeledPrice with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for LabeledPrice"))
  }
  let label : String = @json.from_json(object["label"], path~)
  let amount : Int = @json.from_json(object["amount"], path~)
  { label, amount }
}

///|
/// This object represents a shipping address.
pub struct ShippingAddress {
  country_code : String
  state : String
  city : String
  street_line1 : String
  street_line2 : String
  post_code : String
} derive(Debug, Eq)

///|
/// Creates a new [ShippingAddress].
pub fn ShippingAddress::new(
  country_code~ : String,
  state~ : String,
  city~ : String,
  street_line1~ : String,
  street_line2~ : String,
  post_code~ : String,
) -> ShippingAddress {
  { country_code, state, city, street_line1, street_line2, post_code }
}

///|
pub impl ToJson for ShippingAddress with to_json(self) {
  let object : Map[String, Json] = {
    "country_code": self.country_code.to_json(),
    "state": self.state.to_json(),
    "city": self.city.to_json(),
    "street_line1": self.street_line1.to_json(),
    "street_line2": self.street_line2.to_json(),
    "post_code": self.post_code.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for ShippingAddress with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for ShippingAddress"))
  }
  let country_code : String = @json.from_json(object["country_code"], path~)
  let state : String = @json.from_json(object["state"], path~)
  let city : String = @json.from_json(object["city"], path~)
  let street_line1 : String = @json.from_json(object["street_line1"], path~)
  let street_line2 : String = @json.from_json(object["street_line2"], path~)
  let post_code : String = @json.from_json(object["post_code"], path~)
  { country_code, state, city, street_line1, street_line2, post_code }
}

///|
/// This object represents information about an order.
pub struct OrderInfo {
  name : String?
  phone_number : String?
  email : String?
  shipping_address : ShippingAddress?
} derive(Debug, Eq)

///|
/// Creates a new [OrderInfo].
pub fn OrderInfo::new(
  name? : String,
  phone_number? : String,
  email? : String,
  shipping_address? : ShippingAddress,
) -> OrderInfo {
  { name, phone_number, email, shipping_address }
}

///|
pub impl ToJson for OrderInfo with to_json(self) {
  let object : Map[String, Json] = {}
  if self.name is Some(v) {
    object["name"] = v.to_json()
  }
  if self.phone_number is Some(v) {
    object["phone_number"] = v.to_json()
  }
  if self.email is Some(v) {
    object["email"] = v.to_json()
  }
  if self.shipping_address is Some(v) {
    object["shipping_address"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for OrderInfo with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for OrderInfo"))
  }
  let name : String? = if object.get("name") is Some(v) {
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
  let shipping_address : ShippingAddress? = if object.get("shipping_address")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { name, phone_number, email, shipping_address }
}

///|
/// This object represents one shipping option.
pub struct ShippingOption {
  id : String
  title : String
  prices : Array[LabeledPrice]
} derive(Debug, Eq)

///|
/// Creates a new [ShippingOption].
pub fn ShippingOption::new(
  id~ : String,
  title~ : String,
  prices~ : Array[LabeledPrice],
) -> ShippingOption {
  { id, title, prices }
}

///|
pub impl ToJson for ShippingOption with to_json(self) {
  let object : Map[String, Json] = {
    "id": self.id.to_json(),
    "title": self.title.to_json(),
    "prices": self.prices.to_json(),
  }
  object.to_json()
}

///|
pub impl @json.FromJson for ShippingOption with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for ShippingOption"))
  }
  let id : String = @json.from_json(object["id"], path~)
  let title : String = @json.from_json(object["title"], path~)
  let prices : Array[LabeledPrice] = @json.from_json(object["prices"], path~)
  { id, title, prices }
}

///|
/// This object contains basic information about a successful payment.
pub struct SuccessfulPayment {
  currency : String
  total_amount : Int
  invoice_payload : String
  shipping_option_id : String?
  order_info : OrderInfo?
  telegram_payment_charge_id : String
  provider_payment_charge_id : String
} derive(Debug, Eq)

///|
/// Creates a new [SuccessfulPayment].
pub fn SuccessfulPayment::new(
  currency~ : String,
  total_amount~ : Int,
  invoice_payload~ : String,
  shipping_option_id? : String,
  order_info? : OrderInfo,
  telegram_payment_charge_id~ : String,
  provider_payment_charge_id~ : String,
) -> SuccessfulPayment {
  {
    currency,
    total_amount,
    invoice_payload,
    shipping_option_id,
    order_info,
    telegram_payment_charge_id,
    provider_payment_charge_id,
  }
}

///|
pub impl ToJson for SuccessfulPayment with to_json(self) {
  let object : Map[String, Json] = {
    "currency": self.currency.to_json(),
    "total_amount": self.total_amount.to_json(),
    "invoice_payload": self.invoice_payload.to_json(),
    "telegram_payment_charge_id": self.telegram_payment_charge_id.to_json(),
    "provider_payment_charge_id": self.provider_payment_charge_id.to_json(),
  }
  if self.shipping_option_id is Some(v) {
    object["shipping_option_id"] = v.to_json()
  }
  if self.order_info is Some(v) {
    object["order_info"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for SuccessfulPayment with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for SuccessfulPayment"))
  }
  let currency : String = @json.from_json(object["currency"], path~)
  let total_amount : Int = @json.from_json(object["total_amount"], path~)
  let invoice_payload : String = @json.from_json(
    object["invoice_payload"],
    path~,
  )
  let shipping_option_id : String? = if object.get("shipping_option_id")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let order_info : OrderInfo? = if object.get("order_info") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let telegram_payment_charge_id : String = @json.from_json(
    object["telegram_payment_charge_id"],
    path~,
  )
  let provider_payment_charge_id : String = @json.from_json(
    object["provider_payment_charge_id"],
    path~,
  )
  {
    currency,
    total_amount,
    invoice_payload,
    shipping_option_id,
    order_info,
    telegram_payment_charge_id,
    provider_payment_charge_id,
  }
}

///|
/// This object contains basic information about a refunded payment.
pub struct RefundedPayment {
  currency : String
  total_amount : Int
  invoice_payload : String
  telegram_payment_charge_id : String
  provider_payment_charge_id : String?
} derive(Debug, Eq)

///|
/// Creates a new [RefundedPayment].
pub fn RefundedPayment::new(
  currency~ : String,
  total_amount~ : Int,
  invoice_payload~ : String,
  telegram_payment_charge_id~ : String,
  provider_payment_charge_id? : String,
) -> RefundedPayment {
  {
    currency,
    total_amount,
    invoice_payload,
    telegram_payment_charge_id,
    provider_payment_charge_id,
  }
}

///|
pub impl ToJson for RefundedPayment with to_json(self) {
  let object : Map[String, Json] = {
    "currency": self.currency.to_json(),
    "total_amount": self.total_amount.to_json(),
    "invoice_payload": self.invoice_payload.to_json(),
    "telegram_payment_charge_id": self.telegram_payment_charge_id.to_json(),
  }
  if self.provider_payment_charge_id is Some(v) {
    object["provider_payment_charge_id"] = v.to_json()
  }
  object.to_json()
}

///|
pub impl @json.FromJson for RefundedPayment with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for RefundedPayment"))
  }
  let currency : String = @json.from_json(object["currency"], path~)
  let total_amount : Int = @json.from_json(object["total_amount"], path~)
  let invoice_payload : String = @json.from_json(
    object["invoice_payload"],
    path~,
  )
  let telegram_payment_charge_id : String = @json.from_json(
    object["telegram_payment_charge_id"],
    path~,
  )
  let provider_payment_charge_id : String? = if object.get(
      "provider_payment_charge_id",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    currency,
    total_amount,
    invoice_payload,
    telegram_payment_charge_id,
    provider_payment_charge_id,
  }
}
