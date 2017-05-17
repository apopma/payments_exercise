require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  def json_body
    JSON.parse(response.body)
  end

  before do
    @loan = Loan.create!(funded_amount: 1000.0)
    @payment1 = Payment.create!(loan: @loan, payment_amount: 100.0, payment_date: DateTime.now)
    @payment2 = Payment.create!(loan: @loan, payment_amount: 100.0, payment_date: DateTime.now)
  end

  describe '#index' do
    it 'returns 400 if a loan_id is not given' do
      get :index
      expect(response.status).to eq 400
    end

    it 'returns all payments made to the specified loan_id' do
      get :index, loan_id: 1
      expect(response.status).to eq 200
      expect(json_body.size).to eq 2
      json_body.each do |payment|
        expect(payment["loan_id"]).to eq @loan.id
        expect(payment["payment_amount"].to_i).to eq Payment.find(payment["id"]).payment_amount
      end
    end
  end

  describe '#show' do
    it 'returns 404 for nonexistent payment ids' do
      get :show, id: 10000
      expect(response.status).to eq 404
    end

    it 'returns info on the specified payment' do
      get :show, id: @payment2.id
      expect(response.body).to eq @payment2.to_json
    end
  end

  describe '#create' do
    before(:each) do
      @loan = Loan.create!(funded_amount: 1000.0)
      expect(@loan.payments.count).to be_zero
    end

    it 'returns 400 if no params are given' do
      post :create
      expect(response.status).to eq 400
    end

    it 'returns 404 if a nonexistent loan_id is given' do
      post :create, loan_id: 10000, payment_amount: 500.0
      expect(response.status).to eq 404
    end

    it 'returns 400 if a loan_id is given without a corresponding payment_amount' do
      post :create, loan_id: @loan.id
      expect(response.status).to eq 400
    end

    it 'creates a payment for the given loan at the given payment_amount' do
      post :create, loan_id: @loan.id, payment_amount: 500.0
      expect(response.status).to eq 201
      expect(response.body).to eq @loan.payments.first.to_json
    end

    it '400s if the payment amount is negative' do
      post :create, loan_id: @loan.id, payment_amount: -500.0
      expect(response.status).to eq 400
      expect(@loan.payments.count).to be_zero
    end

    it '400s if the payment amount exceeds the loan balance' do
      post :create, loan_id: @loan.id, payment_amount: 2000.0
      expect(response.status).to eq 400
      expect(@loan.payments.count).to be_zero
    end

    it '500s if something unexpected happens during payment creation' do
      allow(Payment).to receive(:create!).and_raise('kablooie!')
      post :create, loan_id: @loan.id, payment_amount: 500.0
      expect(response.status).to eq 500
      expect(@loan.payments.count).to be_zero
    end
  end
end
