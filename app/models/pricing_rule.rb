class PricingRule < ActiveRecord::Base

  validates_presence_of :code, :quantity

  validates_presence_of :quantity_free, unless: :accumulate

  validate :check_quantity_free, if: :check_quantity_free?

  validates_presence_of :discount, if: :accumulate

  validates_inclusion_of :accumulate, in: [true, false]

  validates_uniqueness_of :code

  has_many :products


  protected

    def check_quantity_free?
      !accumulate && quantity && quantity_free
    end

    def check_quantity_free
      if quantity_free > quantity
        self.errors.add(:quantity_free, I18n.t('activerecord.errors.models.pricing_rule.quantity_free_greater_than_quantity'))
      end
    end

end