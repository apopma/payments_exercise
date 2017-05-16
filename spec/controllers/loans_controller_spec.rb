require 'rails_helper'

# TODO move this method to helper file
def json_body
  JSON.parse(response.body)
end

RSpec.describe LoansController, type: :controller do
  describe '#index' do
    before(:each) do
      @loan1 = Loan.create!(funded_amount: 1000.0)
      @loan2 = Loan.create!(funded_amount: 500.0)
      @loan3 = Loan.create!(funded_amount: 100.0)

      @loan1_pmt1 = Payment.create!(loan: @loan1, payment_amount: 100.0, payment_date: DateTime.now)
      @loan1_pmt2 = Payment.create!(loan: @loan1, payment_amount: 100.0, payment_date: DateTime.now)

      @loan2_pmt1 = Payment.create!(loan: @loan2, payment_amount: 250.0, payment_date: DateTime.now)
      @loan2_pmt2 = Payment.create!(loan: @loan2, payment_amount: 250.0, payment_date: DateTime.now)
    end

    it 'responds with a 200' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'includes the outstanding balance for each loan' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(json_body.size).to eq 3

      json_body.each do |response_json|
        loan = Loan.find(response_json["id"])
        expect(loan.outstanding_balance).to eq response_json["outstanding_balance"].to_i
      end
    end
  end

  describe '#show' do
    before(:each) do
      @loan = Loan.create!(funded_amount: 100.0)
      @payment = Payment.create!(loan: @loan, payment_amount: 25.0, payment_date: DateTime.now)
    end

    it 'responds with a 200' do
      get :show, id: @loan.id
      expect(response).to have_http_status(:ok)
    end

    it 'exposes the outstanding loan balance' do
      get :show, id: @loan.id
      expect(response).to have_http_status(:ok)
      expect(json_body["outstanding_balance"].to_i).to eq 75.0
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        get :show, id: 10000
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
