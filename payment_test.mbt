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
