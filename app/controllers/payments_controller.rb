class PaymentsController < ApplicationController
  before_action -> { params.require :loan_id }, only: [:index, :create]
  before_action -> { params.require :payment_amount }, only: :create
  before_action :validate_create, only: :create

  def index
    render json: Payment.where(loan: params[:loan_id])
  end

  def show
    params.require :id
    render json: Payment.find(params[:id])
  end

  def create
    begin
      payment = Payment.create!(
        loan: @loan,
        payment_amount: params[:payment_amount],
        payment_date: DateTime.now
      )

      render json: payment, status: :created
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end

  private
  def validate_create
    raise ActiveRecord::RecordNotFound, "no loan found" unless Loan.exists? params[:loan_id]
    raise ActionController::BadRequest, "payment can't be negative" if params[:payment_amount].to_i < 0

    @loan = Loan.includes(:payments).find(params[:loan_id])
    if @loan.payment_exceeds_balance?(params[:payment_amount].to_i)
      raise ActionController::BadRequest, "payment exceeds loan balance"
    end
  end
end
