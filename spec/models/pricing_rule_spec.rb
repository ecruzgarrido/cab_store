require 'rails_helper'

RSpec.describe PricingRule, type: :model do

  describe "db structure" do
    it { is_expected.to have_db_column(:code).of_type(:string) }
    it { is_expected.to have_db_column(:accumulate).of_type(:boolean) }
    it { is_expected.to have_db_column(:quantity).of_type(:integer) }
    it { is_expected.to have_db_column(:quantity_free).of_type(:integer) }
    it { is_expected.to have_db_column(:discount).of_type(:float) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

    it { is_expected.to have_db_index(:code) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:quantity) }

    context 'if not accumulate' do
      before { allow(subject).to receive(:accumulate).and_return(false) }

      it { is_expected.to validate_presence_of(:quantity_free) }
    end

    context 'if accumulate' do
      before { allow(subject).to receive(:accumulate).and_return(true) }

      it { is_expected.to validate_presence_of(:discount) }
    end

    it { is_expected.to validate_inclusion_of(:accumulate).in_array([true, false]) }
    it { is_expected.to validate_uniqueness_of(:code) }

    describe '#check_quantity_free' do

      context 'quantity_free is less than quantity' do
        let(:pricing_rule) { PricingRule.make }

        it { expect(pricing_rule).to be_valid }
      end

      context 'quantity_free is equal than quantity' do
        let(:pricing_rule) { PricingRule.make(quantity_free: 2) }

        it { expect(pricing_rule).to be_valid }
      end

      context 'quantity_free is greater than quantity' do
        let(:pricing_rule) { PricingRule.make(quantity_free: 3) }

        it 'should not be valid' do
          expect(pricing_rule).not_to be_valid
          expect(pricing_rule.errors[:quantity_free]).not_to be_empty
        end
      end
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:products) }
  end
end
