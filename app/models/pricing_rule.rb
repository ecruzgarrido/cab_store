class PricingRule < ActiveRecord::Base

  validates_presence_of :code, :quantity

  validates_inclusion_of :accumulate, in: [true, false]

  validates_uniqueness_of :code

  has_many :products

end