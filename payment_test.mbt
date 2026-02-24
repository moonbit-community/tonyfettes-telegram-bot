///|
test "Invoice JSON round-trip" {
  let invoice = Invoice::new(
    title="Premium Subscription",
    description="Monthly subscription to premium features",
    start_parameter="premium_monthly",
    currency="USD",
    total_amount=999,
  )
  let json = @json.to_json(invoice)
  let parsed : Invoice = @json.from_json(json)
  inspect(parsed.title, content="Premium Subscription")
  inspect(
    parsed.description,
    content="Monthly subscription to premium features",
  )
  inspect(parsed.start_parameter, content="premium_monthly")
  inspect(parsed.currency, content="USD")
  inspect(parsed.total_amount, content="999")
}

///|
test "LabeledPrice JSON round-trip" {
  let price = LabeledPrice::new(label="Product Price", amount=1000)
  let json = @json.to_json(price)
  let parsed : LabeledPrice = @json.from_json(json)
  inspect(parsed.label, content="Product Price")
  inspect(parsed.amount, content="1000")
}

///|
test "ShippingAddress JSON round-trip" {
  let address = ShippingAddress::new(
    country_code="US",
    state="California",
    city="San Francisco",
    street_line1="123 Main St",
    street_line2="Apt 4",
    post_code="94102",
  )
  let json = @json.to_json(address)
  let parsed : ShippingAddress = @json.from_json(json)
  inspect(parsed.country_code, content="US")
  inspect(parsed.state, content="California")
  inspect(parsed.city, content="San Francisco")
  inspect(parsed.street_line1, content="123 Main St")
  inspect(parsed.street_line2, content="Apt 4")
  inspect(parsed.post_code, content="94102")
}

///|
test "OrderInfo JSON round-trip" {
  let address = ShippingAddress::new(
    country_code="US",
    state="California",
    city="San Francisco",
    street_line1="123 Main St",
    street_line2="Apt 4",
    post_code="94102",
  )
  let order_info = OrderInfo::new(
    name="John Doe",
    phone_number="+1234567890",
    email="john@example.com",
    shipping_address=address,
  )
  let json = @json.to_json(order_info)
  let parsed : OrderInfo = @json.from_json(json)
  inspect(parsed.name, content="Some(\"John Doe\")")
  inspect(parsed.phone_number, content="Some(\"+1234567890\")")
  inspect(parsed.email, content="Some(\"john@example.com\")")
  inspect(parsed.shipping_address is Some(_), content="true")
}

///|
test "OrderInfo JSON round-trip empty" {
  let order_info = OrderInfo::new()
  let json = @json.to_json(order_info)
  let parsed : OrderInfo = @json.from_json(json)
  inspect(parsed.name, content="None")
  inspect(parsed.phone_number, content="None")
  inspect(parsed.email, content="None")
  inspect(parsed.shipping_address, content="None")
}

///|
test "ShippingOption JSON round-trip" {
  let prices = [
    LabeledPrice::new(label="Base Price", amount=1000),
    LabeledPrice::new(label="Tax", amount=100),
  ]
  let option = ShippingOption::new(
    id="standard",
    title="Standard Shipping",
    prices~,
  )
  let json = @json.to_json(option)
  let parsed : ShippingOption = @json.from_json(json)
  inspect(parsed.id, content="standard")
  inspect(parsed.title, content="Standard Shipping")
  inspect(parsed.prices.length(), content="2")
  inspect(parsed.prices[0].label, content="Base Price")
  inspect(parsed.prices[1].amount, content="100")
}

///|
test "SuccessfulPayment JSON round-trip" {
  let payment = SuccessfulPayment::new(
    currency="USD",
    total_amount=999,
    invoice_payload="payload123",
    shipping_option_id="standard",
    telegram_payment_charge_id="tg_charge_123",
    provider_payment_charge_id="provider_charge_456",
  )
  let json = @json.to_json(payment)
  let parsed : SuccessfulPayment = @json.from_json(json)
  inspect(parsed.currency, content="USD")
  inspect(parsed.total_amount, content="999")
  inspect(parsed.invoice_payload, content="payload123")
  inspect(parsed.shipping_option_id, content="Some(\"standard\")")
  inspect(parsed.order_info, content="None")
  inspect(parsed.telegram_payment_charge_id, content="tg_charge_123")
  inspect(parsed.provider_payment_charge_id, content="provider_charge_456")
}

///|
test "RefundedPayment JSON round-trip" {
  let payment = RefundedPayment::new(
    currency="XTR",
    total_amount=100,
    invoice_payload="payload456",
    telegram_payment_charge_id="tg_refund_123",
    provider_payment_charge_id="provider_refund_456",
  )
  let json = @json.to_json(payment)
  let parsed : RefundedPayment = @json.from_json(json)
  inspect(parsed.currency, content="XTR")
  inspect(parsed.total_amount, content="100")
  inspect(parsed.invoice_payload, content="payload456")
  inspect(parsed.telegram_payment_charge_id, content="tg_refund_123")
  inspect(
    parsed.provider_payment_charge_id,
    content="Some(\"provider_refund_456\")",
  )
}

///|
test "RefundedPayment JSON round-trip without provider_payment_charge_id" {
  let payment = RefundedPayment::new(
    currency="XTR",
    total_amount=50,
    invoice_payload="payload789",
    telegram_payment_charge_id="tg_refund_789",
  )
  let json = @json.to_json(payment)
  let parsed : RefundedPayment = @json.from_json(json)
  inspect(parsed.currency, content="XTR")
  inspect(parsed.total_amount, content="50")
  inspect(parsed.provider_payment_charge_id, content="None")
}

///|
test "Invoice from fixed JSON" {
  let json = @json.parse(
    (
      #|{"title":"Gold Plan","description":"Access to all features","start_parameter":"gold_plan","currency":"EUR","total_amount":4999}
    ),
  )
  let invoice : Invoice = @json.from_json(json)
  inspect(invoice.title, content="Gold Plan")
  inspect(invoice.description, content="Access to all features")
  inspect(invoice.start_parameter, content="gold_plan")
  inspect(invoice.currency, content="EUR")
  inspect(invoice.total_amount, content="4999")
}

///|
test "LabeledPrice from fixed JSON" {
  let json = @json.parse(
    (
      #|{"label":"Shipping","amount":500}
    ),
  )
  let price : LabeledPrice = @json.from_json(json)
  inspect(price.label, content="Shipping")
  inspect(price.amount, content="500")
}

///|
test "ShippingAddress from fixed JSON" {
  let json = @json.parse(
    (
      #|{"country_code":"DE","state":"Bavaria","city":"Munich","street_line1":"Maximilianstr. 1","street_line2":"","post_code":"80539"}
    ),
  )
  let addr : ShippingAddress = @json.from_json(json)
  inspect(addr.country_code, content="DE")
  inspect(addr.state, content="Bavaria")
  inspect(addr.city, content="Munich")
  inspect(addr.street_line1, content="Maximilianstr. 1")
  inspect(addr.street_line2, content="")
  inspect(addr.post_code, content="80539")
}

///|
test "OrderInfo from fixed JSON with all fields" {
  let json = @json.parse(
    (
      #|{"name":"Jane Smith","phone_number":"+4915112345678","email":"jane@example.de","shipping_address":{"country_code":"DE","state":"Bavaria","city":"Munich","street_line1":"Maximilianstr. 1","street_line2":"Apt 2","post_code":"80539"}}
    ),
  )
  let order : OrderInfo = @json.from_json(json)
  inspect(order.name, content="Some(\"Jane Smith\")")
  inspect(order.phone_number, content="Some(\"+4915112345678\")")
  inspect(order.email, content="Some(\"jane@example.de\")")
  guard order.shipping_address is Some(addr) else {
    fail("Expected shipping_address to be Some")
  }
  inspect(addr.country_code, content="DE")
  inspect(addr.city, content="Munich")
}

///|
test "OrderInfo from fixed JSON empty" {
  let json = @json.parse(
    (
      #|{}
    ),
  )
  let order : OrderInfo = @json.from_json(json)
  inspect(order.name, content="None")
  inspect(order.phone_number, content="None")
  inspect(order.email, content="None")
  inspect(order.shipping_address, content="None")
}

///|
test "ShippingOption from fixed JSON" {
  let json = @json.parse(
    (
      #|{"id":"express","title":"Express Shipping","prices":[{"label":"Express fee","amount":2000},{"label":"Handling","amount":300}]}
    ),
  )
  let opt : ShippingOption = @json.from_json(json)
  inspect(opt.id, content="express")
  inspect(opt.title, content="Express Shipping")
  inspect(opt.prices.length(), content="2")
  inspect(opt.prices[0].label, content="Express fee")
  inspect(opt.prices[0].amount, content="2000")
  inspect(opt.prices[1].label, content="Handling")
  inspect(opt.prices[1].amount, content="300")
}

///|
test "SuccessfulPayment from fixed JSON" {
  let json = @json.parse(
    (
      #|{"currency":"USD","total_amount":1999,"invoice_payload":"order_123","telegram_payment_charge_id":"tg_pay_abc","provider_payment_charge_id":"stripe_ch_xyz"}
    ),
  )
  let payment : SuccessfulPayment = @json.from_json(json)
  inspect(payment.currency, content="USD")
  inspect(payment.total_amount, content="1999")
  inspect(payment.invoice_payload, content="order_123")
  inspect(payment.telegram_payment_charge_id, content="tg_pay_abc")
  inspect(payment.provider_payment_charge_id, content="stripe_ch_xyz")
  inspect(payment.shipping_option_id, content="None")
  inspect(payment.order_info, content="None")
}

///|
test "SuccessfulPayment from fixed JSON with optional fields" {
  let json = @json.parse(
    (
      #|{"currency":"GBP","total_amount":799,"invoice_payload":"sub_456","shipping_option_id":"standard","order_info":{"name":"Bob Brown","email":"bob@example.co.uk"},"telegram_payment_charge_id":"tg_pay_def","provider_payment_charge_id":"stripe_ch_uvw"}
    ),
  )
  let payment : SuccessfulPayment = @json.from_json(json)
  inspect(payment.currency, content="GBP")
  inspect(payment.total_amount, content="799")
  inspect(payment.shipping_option_id, content="Some(\"standard\")")
  guard payment.order_info is Some(oi) else {
    fail("Expected order_info to be Some")
  }
  inspect(oi.name, content="Some(\"Bob Brown\")")
  inspect(oi.email, content="Some(\"bob@example.co.uk\")")
}

///|
test "RefundedPayment from fixed JSON" {
  let json = @json.parse(
    (
      #|{"currency":"XTR","total_amount":250,"invoice_payload":"stars_refund_99","telegram_payment_charge_id":"tg_ref_111","provider_payment_charge_id":"prov_ref_222"}
    ),
  )
  let payment : RefundedPayment = @json.from_json(json)
  inspect(payment.currency, content="XTR")
  inspect(payment.total_amount, content="250")
  inspect(payment.invoice_payload, content="stars_refund_99")
  inspect(payment.telegram_payment_charge_id, content="tg_ref_111")
  inspect(payment.provider_payment_charge_id, content="Some(\"prov_ref_222\")")
}

///|
test "RefundedPayment from fixed JSON without provider_payment_charge_id" {
  let json = @json.parse(
    (
      #|{"currency":"XTR","total_amount":100,"invoice_payload":"stars_refund_77","telegram_payment_charge_id":"tg_ref_333"}
    ),
  )
  let payment : RefundedPayment = @json.from_json(json)
  inspect(payment.currency, content="XTR")
  inspect(payment.total_amount, content="100")
  inspect(payment.invoice_payload, content="stars_refund_77")
  inspect(payment.telegram_payment_charge_id, content="tg_ref_333")
  inspect(payment.provider_payment_charge_id, content="None")
}
