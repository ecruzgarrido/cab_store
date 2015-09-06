class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :code, index: true, unique: true
      t.string :name
      t.float :price
      t.references :pricing_rule, index: true

      t.timestamps
    end
  end
end
