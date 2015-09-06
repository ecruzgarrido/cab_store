class PricingRule < ActiveRecord::Base

  validates_presence_of :code, :quantity

  validates_presence_of :quantity_free, unless: :accumulate

  validates_presence_of :discount, if: :accumulate

  validates_inclusion_of :accumulate, in: [true, false]

  validates_uniqueness_of :code

  has_many :products

end