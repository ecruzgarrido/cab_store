class CreatePricingRules < ActiveRecord::Migration
  def change
    create_table :pricing_rules do |t|
      t.boolean :accumulate, default: false
      t.integer :quantity
      t.string :code, index: true, unique: true

      t.timestamps
    end
  end
end
