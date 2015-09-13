[
    { code: "two_for_one", accumulate: false, quantity: 2, quantity_free: 1 },
    { code: "bulk_purchases", accumulate: true, quantity: 3, discount: 1 }
].each do |pricing_rule_attributes|
  PricingRule.create_with(pricing_rule_attributes.except(:code)).find_or_create_by(pricing_rule_attributes.slice(:code))
end

[
    { code: "VOUCHER", name: "Cabify Voucher", price: 5, pricing_rule_id: PricingRule.find_by(code: 'two_for_one').id },
    { code: "TSHIRT", name: "Cabify T-Shirt", price: 20, pricing_rule_id: PricingRule.find_by(code: 'bulk_purchases').id },
    { code: "MUG", name: "Cabify Coffee Mug", price: 7.5 }
].each do |product_attributes|
  Product.create_with(product_attributes.except(:code)).find_or_create_by(product_attributes.slice(:code))
end