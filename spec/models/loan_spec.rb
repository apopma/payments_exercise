require 'rails_helper'

RSpec.describe Loan, type: :model do
  describe "#outstanding_balance" do
    before(:each) do
      loan = Loan.create!(funded_amount: 100.0)
      payment1 = Payment.create!(loan: loan, payment_amount: 25.0, payment_date: DateTime.now)
      payment2 = Payment.create!(loan: loan, payment_amount: 10.0, payment_date: DateTime.now)
    end


    it "calculates using all associated payment amounts" do
      expect(Loan.first.outstanding_balance).to eq 65.0
    end
  end
end
