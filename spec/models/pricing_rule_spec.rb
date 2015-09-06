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

    context 'if not accumulate' do
      before { allow(subject).to receive(:accumulate).and_return(true) }

      it { is_expected.to validate_presence_of(:discount) }
    end

    it { is_expected.to validate_inclusion_of(:accumulate).in_array([true, false]) }
    it { is_expected.to validate_uniqueness_of(:code) }
  end

  describe "associations" do
    it { is_expected.to have_many(:products) }
  end
end
