class Product < ActiveRecord::Base

  validates_presence_of :code, :name, :price

  validates_uniqueness_of :code

  belongs_to :pricing_rule
end