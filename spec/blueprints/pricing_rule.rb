PricingRule.blueprint do
  code { "discount_#{sn}_promotions" }
  accumulate { false }
  quantity { 2 }
  quantity_free { 1 }
end