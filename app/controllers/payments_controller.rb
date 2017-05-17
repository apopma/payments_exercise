class PaymentsController < ApplicationController
  before_action -> { params.require :loan_id }, only: [:index, :create]

  def index
    render json: Payment.where(loan: params[:loan_id])
  end

  def show
    params.require :id
    render json: Payment.find(params[:id])
  end

  def create
    raise NotImplementedError
  end
end
