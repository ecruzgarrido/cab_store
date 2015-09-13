class AddDiscountToPricingRules < ActiveRecord::Migration
  def change
    add_column(:pricing_rules, :discount, :float)
    add_column(:pricing_rules, :quantity_free, :integer)
  end
end
