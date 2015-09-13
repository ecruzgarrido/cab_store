class Checkout
  attr_reader :pricing_rules, :products, :bill

  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @products = []
    @bill = 0
  end

  def scan(product)
    @products << product
  end

  def total
    total_products
    apply_discounts
    bill
  end

  private

    def total_products
      @bill = products.sum(&:price)
    end

    def apply_discounts
      pricing_rules_to_array.sum do |pricing_rule|
        discount_by_pricing_rule(pricing_rule)
      end
    end

    def pricing_rules_to_array
      pricing_rules.is_a?(Array) ? pricing_rules : pricing_rules.to_a
    end

    def discount_by_pricing_rule(pricing_rule)
      products_by_pricing_rule = products_by_pricing_rule(pricing_rule.id)

      products_code_by_pricing_rule(products_by_pricing_rule).each do |product_code|
        number_products_by_code = number_products_by_code(products_by_pricing_rule, product_code)
        if apply_discount?(number_products_by_code, pricing_rule)
          @bill -= apply_discount(number_products_by_code, pricing_rule, product_code)
        end
      end
    end

    def apply_discount?(number_products_by_code, pricing_rule)
      number_products_by_code >= pricing_rule.quantity
    end

    def apply_discount(number_products_by_code, pricing_rule, product_code)
      if pricing_rule.accumulate
        bulk_purchases_discount(number_products_by_code, pricing_rule)
      else
        x_for_y_promotion_discount(number_products_by_code, pricing_rule, product_code)
      end
    end


    def bulk_purchases_discount(number_products_by_code, pricing_rule)
      number_products_by_code * pricing_rule.discount
    end

    def x_for_y_promotion_discount(number_products_by_code, pricing_rule, product_code)
      product = product_by_code(product_code)
      (number_products_discount(number_products_by_code, pricing_rule) * pricing_rule.quantity_free) * product.price
    end

    def number_products_discount(number_products_by_code, pricing_rule)
      number_products_by_code / pricing_rule.quantity
    end

    def products_by_pricing_rule(pricing_rule_id)
      products.select do |product|
        product.pricing_rule_id == pricing_rule_id
      end
    end

    def products_code_by_pricing_rule(products_by_pricing_rule)
      products_by_pricing_rule.map(&:code).uniq
    end

    def product_by_code(code)
      Product.find_by_code(code)
    end

    def number_products_by_code(products_by_pricing_rule, product_code)
      products_by_pricing_rule.select do |product|
        product.code == product_code
      end.length
    end
end