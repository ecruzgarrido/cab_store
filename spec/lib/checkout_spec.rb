require 'rails_helper'

RSpec.describe Checkout, type: :model do

  describe '#total' do

    let!(:pricing_rules) {
      [
          PricingRule.make!(
              code: "two_for_one",
              accumulate: false,
              quantity: 2,
              quantity_free: 1
          ),
          PricingRule.make!(
              code: "bulk_purchases",
              accumulate: true,
              quantity: 3,
              discount: 1
          )
      ]
    }

    let(:products) {
      {
          voucher: Product.make!(
              code: "VOUCHER",
              name: "Cabify Voucher",
              price: 5,
              pricing_rule_id: PricingRule.find_by(code: 'two_for_one').id
          ),
          tshirt: Product.make!(code: "TSHIRT",
                                 name: "Cabify T-Shirt",
                                 price: 20,
                                 pricing_rule_id: PricingRule.find_by(code: 'bulk_purchases').id
          ),
          mug: Product.make!(
              code: "MUG",
              name: "Cabify Coffee Mug",
              price: 7.5
          )
      }
    }

    let(:checkout) { Checkout.new(pricing_rules) }

    context 'first purchase' do

      before do
        checkout.scan(products[:voucher])
        checkout.scan(products[:tshirt])
        checkout.scan(products[:mug])
      end

      it 'should cost 32.5' do
        expect(checkout.total).to eq(32.5)
      end
    end

    context 'second purchase' do

      before do
        checkout.scan(products[:voucher])
        checkout.scan(products[:tshirt])
        checkout.scan(products[:voucher])
      end

      it 'should cost 25' do
        expect(checkout.total).to eq(25)
      end
    end

    context 'thrird purchase' do

      before do
        checkout.scan(products[:tshirt])
        checkout.scan(products[:tshirt])
        checkout.scan(products[:tshirt])
        checkout.scan(products[:voucher])
        checkout.scan(products[:tshirt])
      end

      it 'should cost 81' do
        expect(checkout.total).to eq(81)
      end
    end

    context 'fourth purchase' do

      before do
        checkout.scan(products[:voucher])
        checkout.scan(products[:tshirt])
        checkout.scan(products[:voucher])
        checkout.scan(products[:voucher])
        checkout.scan(products[:mug])
        checkout.scan(products[:tshirt])
        checkout.scan(products[:tshirt])
      end

      it 'should cost 74.5' do
        expect(checkout.total).to eq(74.5)
      end
    end

  end
end